import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:timezone/data/latest.dart' as tz;

class FirebasePushService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications = 
      FlutterLocalNotificationsPlugin();

  // Callback para cuando se toca una notificación
  static Function(String, Map<String, dynamic>)? onNotificationTapped;

  static Future<void> initNotifications({
    Function(String, Map<String, dynamic>)? onTap,
  }) async {
    try {
      onNotificationTapped = onTap;

      // Inicializar timezone para notificaciones programadas
      if (!kIsWeb) {
        tz.initializeTimeZones();
      }

      if (kIsWeb) {
        print('🌐 Modo Web: Notificaciones push FCM no disponibles');
        return;
      }

      // Configurar Android
      const AndroidInitializationSettings androidSettings = 
          AndroidInitializationSettings('@mipmap/ic_launcher');
      
      const InitializationSettings settings = InitializationSettings(
        android: androidSettings,
      );
      
      // Inicializar notificaciones locales
      await _localNotifications.initialize(
        settings,
        onDidReceiveNotificationResponse: (NotificationResponse details) {
          print('📱 Notificación local tocada: ${details.payload}');
          
          // Llamar al callback si está configurado
          if (onNotificationTapped != null && details.payload != null) {
            // Aquí puedes parsear el payload según tu formato
            final Map<String, dynamic> data = {'id': details.payload};
            onNotificationTapped!(details.payload!, data);
          }
        },
      );

      // Configurar canal de notificaciones para Android
      await _setupNotificationChannel();

      // Pedir permisos
      await _requestPermissions();

      // Configurar handlers
      await _setupMessageHandlers();

      print('✅ Servicio de notificaciones inicializado correctamente');

    } catch (e) {
      print('❌ Error inicializando notificaciones: $e');
    }
  }

  // En firebase_push_service.dart, añade este método:
  static Future<void> testPushNotification() async {
    try {
      // 1. Obtener token
      final token = await getFCMToken();
      print('🔧 TEST - Token FCM: $token');
      
      // 2. Mostrar notificación local
      await showMaintenanceAlert(
        title: '🧪 Test de Notificación',
        body: 'Hora: ${DateTime.now().toLocal()} - Token: ${token?.substring(0, 20)}...',
      );
      
      // 3. Verificar canales
      print('🔧 TEST - Canal configurado: mantenimiento_channel');
      
    } catch (e) {
      print('❌ TEST Error: $e');
    }
  }

  static Future<void> _requestPermissions() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    print('📱 Permisos de notificación: ${settings.authorizationStatus}');
  }

  static Future<void> _setupMessageHandlers() async {
    // Obtener token FCM
    final token = await _messaging.getToken();
    print("🔥 Token FCM: $token");

    // Escuchar token refreshes
    _messaging.onTokenRefresh.listen((newToken) {
      print("♻ Nuevo token FCM: $newToken");
      // Aquí deberías enviar este nuevo token a tu backend
    });

    // Mensaje en primer plano
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
    // App abierta desde notificación
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

    // App cerrada completamente
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundMessage(initialMessage);
    }
  }

  static Future<void> _setupNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'mantenimiento_channel',
      'Alertas de Mantenimiento',
      description: 'Canal para alertas de mantenimiento de motos',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    print('📱 Mensaje en primer plano: ${message.notification?.title}');
    
    // Mostrar notificación local
    _showLocalNotification(
      title: message.notification?.title ?? 'Nueva notificación',
      body: message.notification?.body ?? '',
      payload: message.data['id'] ?? message.messageId,
    );
  }

  static void _handleBackgroundMessage(RemoteMessage message) {
    print('📱 App abierta desde notificación');
    // El provider se encargará de manejar esto
  }

  static Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
    int? notificationId,
  }) async {
    if (kIsWeb) {
      print('🔔 [WEB NOTIFICATION] $title: $body');
      return;
    }

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'mantenimiento_channel',
      'Alertas de Mantenimiento',
      channelDescription: 'Canal para alertas de mantenimiento de motos',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      showWhen: true,
      autoCancel: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );
    
    await _localNotifications.show(
      notificationId ?? DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      details,
      payload: payload,
    );
  }
  
  // Método público para mostrar notificaciones locales
  static Future<void> showMaintenanceAlert({
    required String title,
    required String body,
    String? payload,
  }) async {
    await _showLocalNotification(
      title: title, 
      body: body, 
      payload: payload
    );
  }

  // Para notificaciones programadas (versión simplificada)
  static Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    if (kIsWeb) return;

    try {
      // Usar schedule en lugar de zonedSchedule para mayor compatibilidad
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'mantenimiento_channel',
        'Alertas de Mantenimiento',
        channelDescription: 'Canal para alertas de mantenimiento de motos',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
      );

      // Calcular delay
      final delay = scheduledTime.difference(DateTime.now());
      
      if (delay.inSeconds > 0) {
        await _localNotifications.schedule(
          scheduledTime.millisecondsSinceEpoch.remainder(100000),
          title,
          body,
          DateTime.now().add(delay),
          details,
          payload: payload,
        );
        print('✅ Notificación programada para: $scheduledTime');
      } else {
        // Si ya pasó el tiempo, mostrar inmediatamente
        await showMaintenanceAlert(
          title: title,
          body: body,
          payload: payload,
        );
      }
    } catch (e) {
      print('❌ Error en scheduleNotification: $e');
      await showMaintenanceAlert(
        title: title,
        body: body,
        payload: payload,
      );
    }
  }

  // Método específico para mantenimientos
  static Future<void> scheduleMaintenanceNotification({
    required String title,
    required String body,
    required DateTime maintenanceDate,
    required String motorcycleName,
    required String maintenanceType,
    String? payload,
  }) async {
    if (kIsWeb) return;
    
    try {
      // Programar para 1 día antes del mantenimiento
      final notificationTime = maintenanceDate.subtract(const Duration(days: 1));
      
      // Solo programar si es en el futuro
      if (notificationTime.isAfter(DateTime.now())) {
        
        await scheduleNotification(
          title: title,
          body: body,
          scheduledTime: notificationTime,
          payload: payload ?? 'maintenance_${maintenanceDate.millisecondsSinceEpoch}',
        );
        
        print('✅ Notificación de mantenimiento programada');
      } else {
        print('⚠️ La fecha ya pasó, mostrando notificación inmediata');
        await showMaintenanceAlert(
          title: '⚠️ ¡Mantenimiento vencido!',
          body: body,
          payload: payload,
        );
      }
    } catch (e) {
      print('❌ Error en scheduleMaintenanceNotification: $e');
      await showMaintenanceAlert(
        title: title,
        body: body,
        payload: payload,
      );
    }
  }

  // Obtener token FCM
  static Future<String?> getFCMToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      print('❌ Error obteniendo token: $e');
      return null;
    }
  }

  // Cancelar todas las notificaciones
  static Future<void> cancelAllNotifications() async {
    if (kIsWeb) return;
    await _localNotifications.cancelAll();
  }
}

extension on FlutterLocalNotificationsPlugin {
  Future<void> schedule(int remainder, String title, String body, DateTime add, NotificationDetails details, {String? payload}) async {}
}