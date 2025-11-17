import 'package:flutter/material.dart';
import 'package:frontend_manteniapp/core/services/firebase_push_service.dart';
import 'package:frontend_manteniapp/features/notifications/state/notification_provier.dart';
import '../../notifications/data/notification_model.dart';
import '../data/alert_model.dart';

class AlertProvider extends ChangeNotifier {
  final List<AlertModel> _alertas = [];

  List<AlertModel> get alertasActivas =>
      _alertas.where((a) => a.estado != AlertStatus.actual).toList();

  List<AlertModel> get alerts => _alertas;

  void agregarAlerta(AlertModel alerta) {
    // Evitar duplicados
    if (!_alertas.any((a) => a.id == alerta.id)) {
      _alertas.add(alerta);
      notifyListeners();
    }
  }

  void eliminarAlerta(String id) {
    _alertas.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  void actualizarEstadoAlerta(String id, AlertStatus nuevoEstado) {
    final alerta = _alertas.firstWhere((a) => a.id == id);
    alerta.estado = nuevoEstado;
    notifyListeners();
  }

  void limpiarAlertasResueltas() {
    _alertas.removeWhere((a) => a.estado == AlertStatus.actual);
    notifyListeners();
  }

  void evaluarTodasLasAlertas(
    NotificationProvider notifProvider, {
    int? kmActual,
    DateTime? fechaActual,
  }) {
    for (final alerta in _alertas) {
      evaluarAlerta(
        alerta,
        notifProvider,
        kmActual: kmActual,
        fechaActual: fechaActual ?? DateTime.now(),
      );
    }
  }

  void evaluarAlerta(
    AlertModel alerta,
    NotificationProvider notifProvider, {
    int? kmActual,
    DateTime? fechaActual,
  }) {
    final estadoAnterior = alerta.estado;
    
    // Tipo por km
    if (alerta.tipo == AlertType.kilometraje &&
        kmActual != null &&
        alerta.kmObjetivo != null) {
      if (kmActual >= alerta.kmObjetivo!) {
        alerta.estado = AlertStatus.vencida;
      } else if (kmActual >= alerta.kmObjetivo! - 300) {
        alerta.estado = AlertStatus.proxima;
      } else {
        alerta.estado = AlertStatus.actual;
      }
    }

    // Tipo por fecha
    if (alerta.tipo == AlertType.fecha &&
        fechaActual != null &&
        alerta.fechaObjetivo != null) {
      if (fechaActual.isAfter(alerta.fechaObjetivo!)) {
        alerta.estado = AlertStatus.vencida;
      } else if (fechaActual
          .isAfter(alerta.fechaObjetivo!.subtract(const Duration(days: 7)))) {
        alerta.estado = AlertStatus.proxima;
      } else {
        alerta.estado = AlertStatus.actual;
      }
    }

    /// Cuando cambia a "próxima" o "vencida" → crear notificación
    if ((alerta.estado == AlertStatus.proxima || 
         alerta.estado == AlertStatus.vencida) &&
        estadoAnterior != alerta.estado) {
      
      notifProvider.agregarNotificacion(
        AppNotification(
          id: '${alerta.id}_${DateTime.now().millisecondsSinceEpoch}',
          titulo: _getNotificationTitle(alerta.estado),
          descripcion: alerta.descripcion,
          fecha: DateTime.now(),
        ),
      );

      // Notificación push local
      FirebasePushService.showMaintenanceAlert(
        title: _getNotificationTitle(alerta.estado),
        body: alerta.descripcion,
      );
    }

    notifyListeners();
  }

  String _getNotificationTitle(AlertStatus estado) {
    switch (estado) {
      case AlertStatus.proxima:
        return '⚠️ Mantenimiento Próximo';
      case AlertStatus.vencida:
        return '🚨 Mantenimiento Vencido';
      default:
        return 'Alerta de Mantenimiento';
    }
  }
}