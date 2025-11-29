import 'package:flutter/material.dart';
import '../data/notification_model.dart';

class NotificationProvider extends ChangeNotifier {
  final List<AppNotification> _notificaciones = [];

  List<AppNotification> get notificaciones => _notificaciones;

  void agregarNotificacion(AppNotification notif) {
    _notificaciones.add(notif);
    notifyListeners();
  }

  void marcarComoLeida(String id) {
    final notif = _notificaciones.firstWhere((n) => n.id == id);
    notif.leida = true;
    notifyListeners();
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

}
