import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:frontend_manteniapp/core/services/firebase_push_service.dart';
import '../data/notification_model.dart';

class NotificationProvider extends ChangeNotifier {
  final List<AppNotification> _notificaciones = [];
  
  List<AppNotification> get notificaciones => _notificaciones;

  // Constructor que inicializa las notificaciones push
  NotificationProvider() {
    _initializePushNotifications();
  }

  Future<void> _initializePushNotifications() async {
    // Inicializar el servicio de notificaciones push
    await FirebasePushService.initNotifications();
    
    // Configurar listeners para las notificaciones push
    _setupNotificationListeners();
  }

  void _setupNotificationListeners() {
    // Escuchar notificaciones en primer plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Crear notificación a partir del mensaje push
      final notificacion = AppNotification.fromRemoteMessage(message.toMap());
      
      // Agregar a la lista
      agregarNotificacion(notificacion);
    });

    // Escuchar cuando se toca una notificación (app en background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final notificacion = AppNotification.fromRemoteMessage(message.toMap());
      agregarNotificacion(notificacion);
      
      // Marcar como leída inmediatamente al abrir
      notificacion.leida = true;
      notifyListeners();
      
      // Aquí podrías navegar a una pantalla específica basada en message.data
      _handleNotificationNavigation(message.data);
    });
  }

  void _handleNotificationNavigation(Map<String, dynamic> data) {
    // Ejemplo de cómo manejar navegación basada en datos de notificación
    if (data.containsKey('screen')) {
      // Usar un router global o algo similar
      // Navigator.of(context).pushNamed(data['screen']);
    }
  }

  void agregarNotificacion(AppNotification notif) {
    _notificaciones.insert(0, notif); // Insertar al inicio para las más recientes
    notifyListeners();
    
    // Mostrar notificación local inmediatamente
    FirebasePushService.showMaintenanceAlert(
      title: notif.titulo,
      body: notif.descripcion,
      payload: notif.id,
    );
  }

  void marcarComoLeida(String id) {
    final index = _notificaciones.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notificaciones[index].leida = true;
      notifyListeners();
    }
  }

  void eliminar(String id) {
    _notificaciones.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  void limpiarNotificacionesLeidas() {
    _notificaciones.removeWhere((n) => n.leida);
    notifyListeners();
  }

  void limpiarTodasLasNotificaciones() {
    _notificaciones.clear();
    notifyListeners();
  }

  // Obtener notificaciones no leídas
  int get notificacionesNoLeidas {
    return _notificaciones.where((n) => !n.leida).length;
  }

  // Agregar notificaciones de prueba (para desarrollo)
  void agregarNotificacionDePrueba() {
    final notif = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      titulo: 'Notificación de prueba',
      descripcion: 'Esta es una notificación de prueba generada localmente',
      fecha: DateTime.now(),
      tipo: 'test',
    );
    agregarNotificacion(notif);
  }
}