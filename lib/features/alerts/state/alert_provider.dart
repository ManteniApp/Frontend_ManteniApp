import 'package:flutter/material.dart';
import 'package:frontend_manteniapp/core/services/firebase_push_service.dart';
import 'package:frontend_manteniapp/features/notifications/state/notification_provier.dart';
import '../../notifications/data/notification_model.dart';
import '../data/alert_model.dart';

class AlertProvider extends ChangeNotifier {
  final List<AlertModel> _alertas = [];

  List<AlertModel> get alertasActivas => 
      _alertas.where((a) => a.estado != AlertStatus.resuelta).toList();
  
  List<AlertModel> get alertasNoLeidas => 
      _alertas.where((a) => !a.leida).toList();

  List<AlertModel> get alerts => _alertas;

  void agregarAlerta(AlertModel alerta) {
    if (!_alertas.any((a) => a.id == alerta.id)) {
      _alertas.add(alerta);
      notifyListeners();
    }
  }

  void eliminarAlerta(String id) {
    _alertas.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  void marcarComoLeida(String id) {
    final index = _alertas.indexWhere((a) => a.id == id);
    if (index != -1) {
      _alertas[index].leida = true;
      notifyListeners();
    }
  }

  void marcarComoResuelta(String id) {
    final index = _alertas.indexWhere((a) => a.id == id);
    if (index != -1) {
      _alertas[index].estado = AlertStatus.resuelta;
      _alertas[index].leida = true;
      notifyListeners();
    }
  }

  void actualizarEstadoAlerta(String id, AlertStatus nuevoEstado) {
    final index = _alertas.indexWhere((a) => a.id == id);
    if (index != -1) {
      _alertas[index].estado = nuevoEstado;
      notifyListeners();
    }
  }

  void limpiarAlertasResueltas() {
    _alertas.removeWhere((a) => a.estado == AlertStatus.resuelta);
    notifyListeners();
  }

  //CORREGIDO: Crear alertas basadas en mantenimientos reales SIN DUPLICADOS
  void crearAlertasDesdeMantenimiento({
    required String mantenimientoId,
    required String descripcion,
    required String motoId,
    required String motoNombre,
    required DateTime fechaRealizacion,
    required int? proximoKm,
    required int? proximosMeses,
    required int kmActual,
  }) {
    // Eliminar alertas antiguas para ESTE mantenimiento específico
    _alertas.removeWhere((a) => a.motoId == motoId);
    
    // 🔥 SOLUCIÓN: Solo crear alertas FUTURAS
    bool alertaCreada = false;

    // 1. PRIORIDAD: Crear alerta por kilometraje (si es futura)
    if (proximoKm != null && proximoKm > 0) {
      final kmObjetivo = kmActual + proximoKm;
      
      // Solo crear si el KM objetivo es en el FUTURO
      if (kmObjetivo > kmActual) {
        final alertaKm = AlertModel(
          id: '${mantenimientoId}_km',
          tipo: AlertType.kilometraje,
          descripcion: _getDescripcionAlerta(descripcion, 'kilometraje'),
          detalle: 'Próxima revisión en: $proximoKm km',
          motoId: motoId,
          motoNombre: motoNombre,
          mantenimientoId: mantenimientoId,
          kmObjetivo: kmObjetivo,
          estado: AlertStatus.actual,
          leida: false,
          fechaCreacion: DateTime.now(),
        );
        agregarAlerta(alertaKm);
        alertaCreada = true;
      }
    }

    // 2. ALTERNATIVA: Si no hay alerta por KM, crear por fecha (si es futura)
    if (!alertaCreada && proximosMeses != null && proximosMeses > 0) {
      final fechaObjetivo = fechaRealizacion.add(Duration(days: proximosMeses * 30));
      
      // Solo crear si la fecha objetivo es en el FUTURO
      if (fechaObjetivo.isAfter(DateTime.now())) {
        final alertaFecha = AlertModel(
          id: '${mantenimientoId}_fecha',
          tipo: AlertType.fecha,
          descripcion: _getDescripcionAlerta(descripcion, 'fecha'),
          detalle: 'Próxima revisión en: $proximosMeses meses',
          motoId: motoId,
          motoNombre: motoNombre,
          mantenimientoId: mantenimientoId,
          fechaObjetivo: fechaObjetivo,
          estado: AlertStatus.actual,
          leida: false,
          fechaCreacion: DateTime.now(),
        );
        agregarAlerta(alertaFecha);
      }
    }
  }

  String _getDescripcionAlerta(String tipoMantenimiento, String tipoAlerta) {
    if (tipoAlerta == 'kilometraje') {
      return 'Revisión de $tipoMantenimiento programada';
    } else {
      return '$tipoMantenimiento programado';
    }
  }

  // 🔥 NUEVO: Método para regenerar TODAS las alertas desde mantenimientos
  void regenerarTodasLasAlertas({
    required List<Map<String, dynamic>> mantenimientos,
    required String motoId,
    required String motoNombre,
    required int kmActual,
  }) {
    // 1. Limpiar TODAS las alertas existentes para esta moto
    _alertas.removeWhere((a) => a.motoId == motoId);
    
    // 2. Procesar cada mantenimiento y crear alertas
    for (final mantenimiento in mantenimientos) {
      final tipo = mantenimiento['tipo']?.toString() ?? 'Mantenimiento';
      final proximoKm = _getProximoKmPorTipo(tipo);
      final proximosMeses = _getProximosMesesPorTipo(tipo);
      
      crearAlertasDesdeMantenimiento(
        mantenimientoId: mantenimiento['id'].toString(),
        descripcion: tipo,
        motoId: motoId,
        motoNombre: motoNombre,
        fechaRealizacion: DateTime.parse(mantenimiento['fecha']),
        proximoKm: proximoKm,
        proximosMeses: proximosMeses,
        kmActual: kmActual,
      );
    }
    
    notifyListeners();
  }

  // 🔥 Métodos auxiliares para determinar intervalos
  int? _getProximoKmPorTipo(String tipo) {
    final Map<String, int> kmPorTipo = {
      'Cambio de aceite': 1000,
      'Electrico': 5000,
      'Batería': 5000,
      'Afinamiento': 3000,
      'Suspensión': 4000,
      'Frenos': 4000,
    };
    return kmPorTipo[tipo];
  }

  int? _getProximosMesesPorTipo(String tipo) {
    final Map<String, int> mesesPorTipo = {
      'Cambio de aceite': 3,
      'Electrico': 6,
      'Batería': 6,
      'Afinamiento': 4,
      'Suspensión': 2,
      'Frenos': 2,
    };
    return mesesPorTipo[tipo];
  }

  // EVALUACIÓN EN TIEMPO REAL con notificaciones mejoradas
  void evaluarTodasLasAlertas(
    NotificationProvider notifProvider, {
    int? kmActual,
    DateTime? fechaActual,
  }) {
    final ahora = fechaActual ?? DateTime.now();
    
    for (final alerta in _alertas) {
      if (alerta.estado != AlertStatus.resuelta) {
        evaluarAlertaEnTiempoReal(
          alerta,
          notifProvider,
          kmActual: kmActual,
          fechaActual: ahora,
        );
      }
    }
  }

  void evaluarAlertaEnTiempoReal(
    AlertModel alerta,
    NotificationProvider notifProvider, {
    int? kmActual,
    DateTime? fechaActual,
  }) {
    if (alerta.estado == AlertStatus.resuelta) return;
    
    final estadoAnterior = alerta.estado;
    final ahora = fechaActual ?? DateTime.now();
    
    // Evaluar alertas por kilometraje
    if (alerta.tipo == AlertType.kilometraje && 
        kmActual != null && 
        alerta.kmObjetivo != null) {
      
      if (kmActual >= alerta.kmObjetivo!) {
        alerta.estado = AlertStatus.vencida;
      } else if (kmActual >= alerta.kmObjetivo! - 100) {
        alerta.estado = AlertStatus.proxima;
      } else {
        alerta.estado = AlertStatus.actual;
      }
    }

    // Evaluar alertas por fecha
    if (alerta.tipo == AlertType.fecha && alerta.fechaObjetivo != null) {
      if (ahora.isAfter(alerta.fechaObjetivo!)) {
        alerta.estado = AlertStatus.vencida;
      } else if (ahora.isAfter(alerta.fechaObjetivo!.subtract(const Duration(days: 7)))) {
        alerta.estado = AlertStatus.proxima;
      } else {
        alerta.estado = AlertStatus.actual;
      }
    }

    // 🔥 NOTIFICACIONES EN TIEMPO REAL MEJORADAS
    if ((alerta.estado == AlertStatus.proxima || 
         alerta.estado == AlertStatus.vencida) &&
        estadoAnterior != alerta.estado) {
      
      _enviarNotificacionEnTiempoReal(alerta, notifProvider, estadoAnterior);
    }

    notifyListeners();
  }

  // 🔥 NUEVO: Método para notificaciones en tiempo real
  void _enviarNotificacionEnTiempoReal(
    AlertModel alerta,
    NotificationProvider notifProvider,
    AlertStatus estadoAnterior,
  ) {
    final titulo = _getNotificationTitle(alerta.estado);
    final cuerpo = _getNotificationBody(alerta);
    
    // Notificación en la app
    notifProvider.agregarNotificacion(
      AppNotification(
        id: '${alerta.id}_${DateTime.now().millisecondsSinceEpoch}',
        titulo: titulo,
        descripcion: cuerpo,
        fecha: DateTime.now(),
        tipo: _getTipoNotificacion(alerta.estado),
      ),
    );

    // Notificación push local (solo para estados importantes)
    if (alerta.estado == AlertStatus.vencida || alerta.estado == AlertStatus.proxima) {
      FirebasePushService.showMaintenanceAlert(
        title: titulo,
        body: cuerpo,
      );
    }
  }

  String _getNotificationBody(AlertModel alerta) {
    if (alerta.tipo == AlertType.kilometraje && alerta.kmObjetivo != null) {
      return '${alerta.descripcion}\nMoto: ${alerta.motoNombre}\nObjetivo: ${alerta.kmObjetivo} km';
    } else if (alerta.tipo == AlertType.fecha && alerta.fechaObjetivo != null) {
      return '${alerta.descripcion}\nMoto: ${alerta.motoNombre}\nVence: ${_formatearFecha(alerta.fechaObjetivo!)}';
    }
    return '${alerta.descripcion}\nMoto: ${alerta.motoNombre}';
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }

  String _getNotificationTitle(AlertStatus estado) {
    switch (estado) {
      case AlertStatus.proxima:
        return '⚠️ Mantenimiento Próximo';
      case AlertStatus.vencida:
        return '🚨 Mantenimiento Vencido';
      case AlertStatus.actual:
        return '📋 Mantenimiento Programado';
      default:
        return 'Alerta de Mantenimiento';
    }
  }

  String _getTipoNotificacion(AlertStatus estado) {
    switch (estado) {
      case AlertStatus.vencida:
        return 'urgente';
      case AlertStatus.proxima:
        return 'aviso';
      default:
        return 'info';
    }
  }

  // 🔥 NUEVO: Evaluar cambios de kilometraje en tiempo real
  void actualizarKilometrajeEnTiempoReal(
    int nuevoKm, 
    NotificationProvider notifProvider
  ) {
    evaluarTodasLasAlertas(
      notifProvider,
      kmActual: nuevoKm,
      fechaActual: DateTime.now(),
    );
  }

  // Métodos de prueba (mantener)
  void crearAlertaPrueba(AlertModel alerta) {
    agregarAlerta(alerta);
  }

  void crearAlertaDirectaPrueba() {
    final testAlert = AlertModel(
      id: 'direct_test_${DateTime.now().millisecondsSinceEpoch}',
      tipo: AlertType.fecha,
      descripcion: '🚨 ALERTA DE PRUEBA DIRECTA',
      detalle: 'Esta es una alerta de prueba creada directamente',
      motoId: 'test_moto_id',
      motoNombre: 'Moto de Prueba',
      fechaObjetivo: DateTime.now().add(const Duration(days: 5)),
      estado: AlertStatus.proxima,
      leida: false,
      fechaCreacion: DateTime.now(),
    );
    agregarAlerta(testAlert);
  }

  void evaluarAlerta(AlertModel alerta, NotificationProvider notificationProvider, {required kmActual, required DateTime fechaActual}) {
    evaluarAlertaEnTiempoReal(
      alerta,
      notificationProvider,
      kmActual: kmActual,
      fechaActual: fechaActual,
    );
  }
}