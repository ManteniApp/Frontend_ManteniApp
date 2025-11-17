import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter/foundation.dart'; // Para kIsWeb

class FirebasePushService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications = 
      FlutterLocalNotificationsPlugin();

  static Future<void> initNotifications() async {
    try {

      if (kIsWeb) {
        print('🌐 Modo Web: Notificaciones push FCM no disponibles');
        return;
      }
      // Configurar notificaciones locales para Android
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
          // Aquí puedes manejar la navegación cuando se toca una notificación
        },
      );

      // Pedir permisos de notificación
      NotificationSettings notificationSettings = 
          await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      print('📱 Permisos de notificación: ${notificationSettings.authorizationStatus}');

      // Obtener token FCM
      final token = await _messaging.getToken();
      print("🔥 Token FCM: $token");

      // Configurar manejo de mensajes en primer plano
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      
      // Configurar manejo cuando se abre la app desde una notificación
      FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

      // Manejar cuando la app está totalmente cerrada
      RemoteMessage? initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleBackgroundMessage(initialMessage);
      }

      // Escuchar cambios de token
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        print("♻ Nuevo token FCM: $newToken");
        // Actualizar token en tu backend si es necesario
      });

      print('✅ Servicio de notificaciones inicializado correctamente');

    } catch (e) {
      print('❌ Error inicializando notificaciones: $e');
    }
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    print('📱 Mensaje en primer plano: ${message.notification?.title}');
    print('📱 Datos del mensaje: ${message.data}');
    
    // Mostrar notificación local cuando la app está en primer plano
    _showLocalNotification(
      title: message.notification?.title ?? 'Alerta de Mantenimiento',
      body: message.notification?.body ?? 'Nueva alerta generada',
      payload: message.data['type'] ?? 'maintenance',
    );
  }

  static void _handleBackgroundMessage(RemoteMessage message) {
    print('📱 App abierta desde notificación: ${message.notification?.title}');
    print('📱 Datos: ${message.data}');
    
    // Aquí puedes manejar la navegación cuando se abre la app desde una notificación
    // Por ejemplo: Navigator.pushNamed(context, '/alertas');
  }

  static Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    if (kIsWeb) {
      print('🔔 [WEB NOTIFICATION] $title: $body');
      return;
    }
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'mantenimiento_channel', // channelId
      'Alertas de Mantenimiento', // channelName
      channelDescription: 'Canal para alertas de mantenimiento de motos',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );
    
    const DarwinNotificationDetails darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );
    
    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      details,
      payload: payload,
    );
  }

  // Método para enviar notificaciones locales desde la app
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

  // Método para configurar el canal de notificaciones (Android)
  static Future<void> setupNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'mantenimiento_channel',
      'Alertas de Mantenimiento',
      description: 'Canal para alertas de mantenimiento de motos',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
}