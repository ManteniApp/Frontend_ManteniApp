import 'package:flutter/material.dart';
import 'package:frontend_manteniapp/features/motorcycles/presentation/providers/motorcycle_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend_manteniapp/features/alerts/state/alert_provider.dart';
import 'package:frontend_manteniapp/features/maintenance_history/presentation/providers/maintenance_history_provider.dart';
import 'package:frontend_manteniapp/features/notifications/state/notification_provier.dart';
import 'package:frontend_manteniapp/features/alerts/data/alert_model.dart';

class AlertEvaluationService {
  final BuildContext context;

  AlertEvaluationService(this.context);

  Future<void> evaluateExistingMaintenances() async {
    final maintenanceProvider = context.read<MaintenanceHistoryProvider>();
    final alertProvider = context.read<AlertProvider>();
    final motorcycleProvider = context.read<MotorcycleProvider>();
    final notificationProvider = context.read<NotificationProvider>();

    try {
      // LIMPIAR SOLO ALERTAS DE MANTENIMIENTO, NO TODAS
      _limpiarAlertasDeMantenimiento(alertProvider);
      
      final maintenances = maintenanceProvider.maintenances;
      final motorcycles = motorcycleProvider.motorcycles;
      
      print('🚨 INICIANDO EVALUACIÓN DE MANTENIMIENTOS REALES');
      print('🔍 Total mantenimientos: ${maintenances.length}');
      print('🔍 Total motos: ${motorcycles.length}');
      
      if (maintenances.isEmpty) {
        print('❌ No hay mantenimientos para evaluar');
        return;
      }

      if (motorcycles.isEmpty) {
        print('❌ No hay motos registradas');
        return;
      }

      int alertasCreadas = 0;
      
      for (final maintenance in maintenances) {
        try {
          print('\n🔍 ANALIZANDO MANTENIMIENTO:');
          print('   📋 Tipo: ${maintenance.type}');
          print('   📅 Fecha: ${maintenance.date}');
          print('   🏍️ MotoID del mantenimiento: ${maintenance.motorcycleId}');
          print('   🆔 ID: ${maintenance.id}');

          if (maintenance.id == null) {
            print('⚠️ Mantenimiento sin ID, saltando...');
            continue;
          }

          // 🔥 CORRECCIÓN PRINCIPAL: OBTENER LA MOTO CORRECTA PARA ESTE MANTENIMIENTO
          final moto = _obtenerMotoPorId(motorcycles, maintenance.motorcycleId);
          
          if (moto == null) {
            print('❌ No se encontró la moto con ID ${maintenance.motorcycleId} para este mantenimiento');
            continue;
          }

          print('   ✅ Moto encontrada: ${moto['brand']} ${moto['model']} - KM: ${moto['mileage']}');

          // DETERMINAR CRITERIOS INTELIGENTES basados en el tipo de mantenimiento
          final criterios = _determinarCriteriosPorTipo(maintenance);
          final kmActualMoto = moto['mileage'] ?? 0;

          print('   🎯 CRITERIOS DETERMINADOS:');
          print('      Próximo KM: ${criterios['proximoKm']}');
          print('      Próximos Meses: ${criterios['proximosMeses']}');
          print('      KM Actual de la moto: $kmActualMoto');

          // VERIFICAR SI YA EXISTEN ALERTAS PARA ESTE MANTENIMIENTO
          final alertasExistentes = alertProvider.alerts.where((a) => 
              a.mantenimientoId == maintenance.id).toList();
              
          if (alertasExistentes.isNotEmpty) {
            print('   ⏭️ Ya existen ${alertasExistentes.length} alertas para este mantenimiento, saltando...');
            continue;
          }

          // CREAR SOLO ALERTAS FUTURAS
          bool creoAlerta = false;
          
          if (criterios['proximosMeses'] != null && criterios['proximosMeses']! > 0) {
            final fechaObjetivo = maintenance.date.add(Duration(days: criterios['proximosMeses']! * 30));
            // SOLO crear si la fecha es futura
            if (fechaObjetivo.isAfter(DateTime.now())) {
              _crearAlertaFechaInteligente(
                alertProvider,
                maintenance: maintenance,
                moto: moto,
                proximosMeses: criterios['proximosMeses']!,
                tipo: maintenance.type,
              );
              creoAlerta = true;
            } else {
              print('   ⏭️ Alerta FECHA omitida (fecha $fechaObjetivo <= actual)');
            }
          }

          if (creoAlerta) {
            alertasCreadas++;
          }

        } catch (e) {
          print('❌ Error en mantenimiento ${maintenance.id}: $e');
        }
      }

      // EVALUAR ALERTAS EXISTENTES con cada moto correspondiente
      print('\n📊 Evaluando alertas creadas...');
      
      if (alertasCreadas > 0 || alertProvider.alerts.isNotEmpty) {
        // Evaluar cada alerta con el kilometraje correcto de su moto
        for (final alerta in alertProvider.alerts) {
          final motoAlerta = _obtenerMotoPorId(motorcycles, alerta.motoId);
          if (motoAlerta != null) {
            final kmActualMoto = motoAlerta['mileage'] ?? 0;
            alertProvider.evaluarAlerta(
              alerta,
              notificationProvider,
              kmActual: kmActualMoto,
              fechaActual: DateTime.now(),
            );
          }
        }
      }

      print('✅ COMPLETADO - Alertas totales: ${alertProvider.alerts.length}');
      print('✅ Alertas activas: ${alertProvider.alertasActivas.length}');

    } catch (e) {
      print('❌ Error general: $e');
    }
  }

  // 🔥 NUEVO MÉTODO: Obtener moto por ID específico
  Map<String, dynamic>? _obtenerMotoPorId(List<dynamic> motorcycles, String? motorcycleId) {
    if (motorcycleId == null) return null;
    
    for (final moto in motorcycles) {
      final motoId = _obtenerPropiedad(moto, 'id')?.toString();
      if (motoId == motorcycleId.toString()) {
        return {
          'id': motoId,
          'brand': _obtenerPropiedad(moto, 'brand') ?? _obtenerPropiedad(moto, 'marca') ?? 'Desconocida',
          'model': _obtenerPropiedad(moto, 'model') ?? _obtenerPropiedad(moto, 'modelo') ?? 'Desconocido',
          'licensePlate': _obtenerPropiedad(moto, 'licensePlate') ?? _obtenerPropiedad(moto, 'placa') ?? 'Sin placa',
          'mileage': _obtenerPropiedad(moto, 'mileage') ?? _obtenerPropiedad(moto, 'kilometraje') ?? 0,
        };
      }
    }
    
    return null;
  }

  void _limpiarAlertasDeMantenimiento(AlertProvider alertProvider) {
    // SOLO limpiar alertas de mantenimiento, no alertas manuales o del sistema
    final alertasMantenimiento = alertProvider.alerts.where((a) => 
        a.mantenimientoId != null && 
        a.id.startsWith('real_')).toList();
        
    for (var alerta in alertasMantenimiento) {
      alertProvider.eliminarAlerta(alerta.id);
    }
    print('🧹 Limpiadas ${alertasMantenimiento.length} alertas de mantenimiento');
  }

  Map<String, int?> _determinarCriteriosPorTipo(dynamic maintenance) {
    final tipo = maintenance.type?.toString().toLowerCase() ?? '';
    
    // CRITERIOS INTELIGENTES BASADOS EN EL TIPO DE MANTENIMIENTO
    switch (tipo) {
      case 'cambio de aceite':
      case 'aceite':
        return {'proximoKm': 1000, 'proximosMeses': 3};
      
      case 'batería':
      case 'electrico':
        return {'proximoKm': 5000, 'proximosMeses': 6};
      
      case 'afinamiento':
      case 'motor':
        return {'proximoKm': 3000, 'proximosMeses': 4};
      
      case 'suspensión':
      case 'frenos':
        return {'proximoKm': 4000, 'proximosMeses': 6};
      
      case 'filtro de aire':
        return {'proximoKm': 2000, 'proximosMeses': 3};
      
      case 'cadena':
      case 'transmisión':
        return {'proximoKm': 1000, 'proximosMeses': 2};

      case 'llantas':
        return {'proximoKm': 8000, 'proximosMeses': 12};
      
      default:
        return {'proximoKm': 2000, 'proximosMeses': 3};
    }
  }

  void _crearAlertaFechaInteligente(
    AlertProvider alertProvider, {
    required maintenance,
    required Map<String, dynamic> moto,
    required int proximosMeses,
    required String tipo,
  }) {
    final fechaObjetivo = maintenance.date.add(Duration(days: proximosMeses * 30));
    final descripciones = {
      'cambio de aceite': 'Cambio de aceite programado',
      'batería': 'Revisión de batería programada',
      'electrico': 'Revisión eléctrica programada',
      'afinamiento': 'Afinamiento programado',
      'suspensión': 'Revisión de suspensión programada',
      'frenos': 'Revisión de frenos programada',
      'llantas': 'Revisión de llantas programada',
    };
    
    final descripcion = descripciones[tipo.toLowerCase()] ?? 'Mantenimiento programado: $tipo';
    final detalle = _generarDetalleInteligente(tipo, null, proximosMeses);
    
    final alerta = AlertModel(
      id: 'real_fecha_${maintenance.id}_${DateTime.now().millisecondsSinceEpoch}',
      tipo: AlertType.fecha,
      descripcion: '$descripcion - ${fechaObjetivo.day}/${fechaObjetivo.month}',
      detalle: detalle,
      motoId: moto['id']!,
      motoNombre: '${moto['brand']} ${moto['model']}',
      mantenimientoId: maintenance.id!,
      fechaObjetivo: fechaObjetivo,
      estado: AlertStatus.actual,
      leida: false,
      fechaCreacion: DateTime.now(),
    );
    
    alertProvider.agregarAlerta(alerta);
    print('   📅 Alerta FECHA INTELIGENTE para ${moto['brand']}: $descripcion - ${fechaObjetivo.day}/${fechaObjetivo.month}');
  }

  String _generarDetalleInteligente(String tipo, int? proximoKm, int? proximosMeses) {
    final detalles = {
      'cambio de aceite': 'Cambio de aceite y filtro. Mantén el motor lubricado y limpio.',
      'batería': 'Revisión del estado de la batería y sistema de carga.',
      'electrico': 'Revisión completa del sistema eléctrico y luces.',
      'afinamiento': 'Ajuste de carburación/inyección y verificación de bujías.',
      'suspensión': 'Revisión de amortiguadores, horquilla y estabilidad.',
      'frenos': 'Verificación de pastillas, discos y líquido de frenos.',
      'llantas': 'Revisión de presión, desgaste y estado general de las llantas.',
    };
    
    var detalle = detalles[tipo.toLowerCase()] ?? 'Mantenimiento de $tipo para mantener tu moto en óptimas condiciones.';
    
    if (proximoKm != null) {
      detalle += '\nPróxima revisión en: $proximoKm km';
    }
    if (proximosMeses != null) {
      detalle += '\nPróxima revisión en: $proximosMeses meses';
    }
    
    return detalle;
  }

  dynamic _obtenerPropiedad(dynamic obj, String propiedad) {
    try {
      if (obj is Map) return obj[propiedad];
      
      switch (propiedad) {
        case 'id': return obj.id?.toString();
        case 'brand': return obj.brand ?? obj.marca;
        case 'model': return obj.model ?? obj.modelo;
        case 'licensePlate': return obj.licensePlate ?? obj.placa;
        case 'mileage': return obj.mileage ?? obj.kilometraje;
        default: return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> evaluateMaintenanceAlerts() async {
    return evaluateExistingMaintenances();
  }

  Future<void> createRealTestData() async {
    print('🎯 Creando alertas inteligentes desde mantenimientos reales...');
    return evaluateExistingMaintenances();
  }
}