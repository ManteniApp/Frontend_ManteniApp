import 'package:flutter/material.dart';
import 'package:frontend_manteniapp/core/services/firebase_push_service.dart';
import 'package:frontend_manteniapp/features/alerts/data/alert_model.dart';
import 'package:frontend_manteniapp/features/alerts/state/alert_provider.dart';
import 'package:frontend_manteniapp/features/maintenance_history/domain/entities/maintenance_entity.dart';
import 'package:frontend_manteniapp/features/maintenance_history/presentation/providers/maintenance_history_provider.dart';
import 'package:frontend_manteniapp/features/notifications/data/notification_model.dart';
import 'package:frontend_manteniapp/features/notifications/state/notification_provier.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AlertEvaluationService {
  final BuildContext context;

  AlertEvaluationService(this.context);

  // 🔄 EVALUAR MANTENIMIENTOS EXISTENTES
  Future<void> evaluateExistingMaintenances() async {
    try {
      final maintenanceProvider = context.read<MaintenanceHistoryProvider>();
      final alertProvider = context.read<AlertProvider>();
      final notificationProvider = context.read<NotificationProvider>();

      // Forzar la carga del historial
      await maintenanceProvider.loadMaintenanceHistory();
      
      final maintenances = maintenanceProvider.maintenances;
      
      print('🔍 Evaluando ${maintenances.length} mantenimientos existentes...');
      
      for (final maintenance in maintenances) {
        print('📋 Mantenimiento encontrado: ${maintenance.type} - ${maintenance.date}');
        await _evaluateMaintenanceForAlerts(
          maintenance,
          alertProvider,
          notificationProvider,
        );
      }
      
      print('✅ Evaluación de mantenimientos existentes completada');
    } catch (e) {
      print('❌ Error evaluando mantenimientos existentes: $e');
    }
  }

  // 🔄 EVALUAR MANTENIMIENTOS PARA ALERTAS (método general)
  Future<void> evaluateMaintenanceAlerts() async {
    final maintenanceProvider = context.read<MaintenanceHistoryProvider>();
    final alertProvider = context.read<AlertProvider>();
    final notificationProvider = context.read<NotificationProvider>();

    try {
      // Cargar historial de mantenimientos
      await maintenanceProvider.loadMaintenanceHistory();
      
      final maintenances = maintenanceProvider.maintenances;
      
      for (final maintenance in maintenances) {
        await _evaluateMaintenanceForAlerts(
          maintenance,
          alertProvider,
          notificationProvider,
        );
      }
      
      print('✅ Evaluación de alertas completada');
    } catch (e) {
      print('❌ Error evaluando alertas: $e');
    }
  }

  // 🔄 EVALUAR MANTENIMIENTO INDIVIDUAL
  Future<void> _evaluateMaintenanceForAlerts(
    MaintenanceEntity maintenance,
    AlertProvider alertProvider,
    NotificationProvider notificationProvider,
  ) async {
    final now = DateTime.now();
    
    // Evaluar por fecha de próximo mantenimiento
    if (_shouldCreateDateAlert(maintenance, now)) {
      await _createDateAlert(maintenance, alertProvider, notificationProvider);
    }
    
    // Evaluar por kilometraje (si tienes datos de kilometraje)
    if (_shouldCreateMileageAlert(maintenance)) {
      await _createMileageAlert(maintenance, alertProvider, notificationProvider);
    }
  }

  // 📅 VERIFICAR SI SE DEBE CREAR ALERTA POR FECHA
  bool _shouldCreateDateAlert(MaintenanceEntity maintenance, DateTime now) {
    try {
      // Si la fecha del mantenimiento es en el FUTURO, es un mantenimiento programado
      if (maintenance.date.isAfter(now)) {
        final daysUntilMaintenance = maintenance.date.difference(now).inDays;
        
        print('📅 Mantenimiento PROGRAMADO: ${maintenance.type}');
        print('   - Fecha programada: ${maintenance.date}');
        print('   - Días hasta mantenimiento: $daysUntilMaintenance');
        
        // Crear alerta si el mantenimiento programado está dentro de 15 días
        return daysUntilMaintenance <= 15;
      }
      // Si la fecha del mantenimiento es en el PASADO, calcular próximo
      else {
        final nextMaintenanceDate = maintenance.date.add(const Duration(days: 90));
        final daysUntilMaintenance = nextMaintenanceDate.difference(now).inDays;
        
        print('📅 Mantenimiento PASADO: ${maintenance.type}');
        print('   - Último: ${maintenance.date}');
        print('   - Próximo: $nextMaintenanceDate');
        print('   - Días hasta próximo: $daysUntilMaintenance');
        
        // Crear alerta si el próximo mantenimiento está dentro de 30 días
        return daysUntilMaintenance <= 30;
      }
    } catch (e) {
      print('❌ Error calculando fecha de alerta: $e');
      return false;
    }
  }

  // 📏 VERIFICAR SI SE DEBE CREAR ALERTA POR KILOMETRAJE
  bool _shouldCreateMileageAlert(MaintenanceEntity maintenance) {
    // Aquí necesitarías acceder al kilometraje actual de la moto
    // Por ahora retornamos false
    return false;
  }

  // 🚨 CREAR ALERTA POR FECHA
  Future<void> _createDateAlert(
    MaintenanceEntity maintenance,
    AlertProvider alertProvider,
    NotificationProvider notificationProvider,
  ) async {
    try {
      final nextMaintenanceDate = maintenance.date.add(const Duration(days: 90));
      final daysUntil = nextMaintenanceDate.difference(DateTime.now()).inDays;
      
      AlertStatus status;
      if (daysUntil <= 0) {
        status = AlertStatus.vencida;
      } else if (daysUntil <= 7) {
        status = AlertStatus.proxima;
      } else {
        status = AlertStatus.proxima;
      }

      final alertId = 'alert_${maintenance.id}_${maintenance.type}';
      final alertDescription = 'Mantenimiento "${maintenance.type}" para '
          '${maintenance.motorcycleName} '
          '${status == AlertStatus.vencida ? 'VENCIDO' : 'PRÓXIMO'} '
          'en ${daysUntil.abs()} día(s) - '
          'Próxima fecha: ${DateFormat('dd/MM/yyyy').format(nextMaintenanceDate)}';

      // Verificar si la alerta ya existe
      final existingAlert = alertProvider.alerts.firstWhere(
        (a) => a.id == alertId,
        orElse: () => AlertModel(
          id: '',
          tipo: AlertType.fecha,
          descripcion: '',
          estado: AlertStatus.actual,
        ),
      );

      if (existingAlert.id.isEmpty) {
        final alert = AlertModel(
          id: alertId,
          tipo: AlertType.fecha,
          descripcion: alertDescription,
          fechaObjetivo: nextMaintenanceDate,
          estado: status,
        );

        alertProvider.agregarAlerta(alert);
        
        // Crear notificación
        final notification = AppNotification(
          id: 'notif_${alert.id}_${DateTime.now().millisecondsSinceEpoch}',
          titulo: _getNotificationTitle(status),
          descripcion: alert.descripcion,
          fecha: DateTime.now(),
        );
        
        notificationProvider.agregarNotificacion(notification);
        
        // Mostrar notificación push
        await FirebasePushService.showMaintenanceAlert(
          title: _getNotificationTitle(status),
          body: alert.descripcion,
        );

        print('📢 Alerta creada para mantenimiento existente: ${maintenance.type}');
        print('   - Descripción: $alertDescription');
      } else {
        print('ℹ️ Alerta ya existe para: ${maintenance.type}');
      }
    } catch (e) {
      print('❌ Error creando alerta para mantenimiento ${maintenance.type}: $e');
    }
  }

  // 📏 CREAR ALERTA POR KILOMETRAJE
  Future<void> _createMileageAlert(
    MaintenanceEntity maintenance,
    AlertProvider alertProvider,
    NotificationProvider notificationProvider,
  ) async {
    // Implementar lógica similar para alertas por kilometraje
    // Necesitarías acceso al kilometraje actual de la moto
  }

  // 🎯 CREAR DATOS REALES DE PRUEBA
  Future<void> createRealTestData() async {
    final alertProvider = context.read<AlertProvider>();
    final notificationProvider = context.read<NotificationProvider>();

    print('🎯 Creando datos REALES de prueba...');

    // Mantenimientos que SÍ generarán alertas
    final testAlerts = [
      AlertModel(
        id: 'real_test_1_${DateTime.now().millisecondsSinceEpoch}',
        tipo: AlertType.fecha,
        descripcion: '🚨 CAMBIO DE ACEITE URGENTE - Vencido hace 10 días',
        fechaObjetivo: DateTime.now().subtract(const Duration(days: 10)),
        estado: AlertStatus.vencida,
      ),
      AlertModel(
        id: 'real_test_2_${DateTime.now().millisecondsSinceEpoch}',
        tipo: AlertType.fecha,
        descripcion: '⚠️ REVISIÓN DE FRENOS - Próximo en 3 días',
        fechaObjetivo: DateTime.now().add(const Duration(days: 3)),
        estado: AlertStatus.proxima,
      ),
      AlertModel(
        id: 'real_test_3_${DateTime.now().millisecondsSinceEpoch}',
        tipo: AlertType.kilometraje,
        descripcion: '📏 FILTRO DE AIRE - Próximo en 150 km',
        kmObjetivo: 5000,
        estado: AlertStatus.proxima,
      ),
    ];

    for (final alert in testAlerts) {
      alertProvider.agregarAlerta(alert);
      
      final notification = AppNotification(
        id: 'real_notif_${alert.id}',
        titulo: alert.estado == AlertStatus.vencida ? '🚨 Alerta Urgente' : '⚠️ Alerta Próxima',
        descripcion: alert.descripcion,
        fecha: DateTime.now(),
      );
      
      notificationProvider.agregarNotificacion(notification);
    }

    print('✅ ${testAlerts.length} alertas REALES creadas');
  }

  // 📦 CREAR DATOS DE PRUEBA BÁSICOS
  Future<void> createSampleData() async {
    final alertProvider = context.read<AlertProvider>();
    final notificationProvider = context.read<NotificationProvider>();

    // Crear alertas de ejemplo
    final sampleAlerts = [
      AlertModel(
        id: 'sample_1_${DateTime.now().millisecondsSinceEpoch}',
        tipo: AlertType.fecha,
        descripcion: 'Cambio de aceite próximo en 3 días',
        fechaObjetivo: DateTime.now().add(const Duration(days: 3)),
        estado: AlertStatus.proxima,
      ),
      AlertModel(
        id: 'sample_2_${DateTime.now().millisecondsSinceEpoch}',
        tipo: AlertType.fecha,
        descripcion: 'Revisión de frenos VENCIDA',
        fechaObjetivo: DateTime.now().subtract(const Duration(days: 5)),
        estado: AlertStatus.vencida,
      ),
      AlertModel(
        id: 'sample_3_${DateTime.now().millisecondsSinceEpoch}',
        tipo: AlertType.kilometraje,
        descripcion: 'Cambio de filtro de aire en 200 km',
        kmObjetivo: 5000,
        estado: AlertStatus.proxima,
      ),
    ];

    for (final alert in sampleAlerts) {
      alertProvider.agregarAlerta(alert);
      
      // Crear notificación para cada alerta
      final notification = AppNotification(
        id: 'notif_${alert.id}',
        titulo: alert.estado == AlertStatus.vencida ? '🚨 Alerta Vencida' : '⚠️ Alerta Próxima',
        descripcion: alert.descripcion,
        fecha: DateTime.now(),
      );
      
      notificationProvider.agregarNotificacion(notification);
    }

    print('📦 Datos de prueba creados: ${sampleAlerts.length} alertas');
  }

  // 🔔 OBTENER TÍTULO DE NOTIFICACIÓN
  String _getNotificationTitle(AlertStatus estado) {
    switch (estado) {
      case AlertStatus.proxima:
        return '⚠️ Mantenimiento Próximo';
      case AlertStatus.vencida:
        return '🚨 Mantenimiento Vencido';
      default:
        return '📋 Alerta de Mantenimiento';
    }
  }
}