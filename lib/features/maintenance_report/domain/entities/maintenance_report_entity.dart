import 'package:equatable/equatable.dart';

/// Entidad que representa un reporte de mantenimientos
class MaintenanceReportEntity extends Equatable {
  /// Cantidad total de mantenimientos realizados
  final int totalMaintenances;

  /// Coste total de todos los mantenimientos
  final double totalCost;

  /// Coste promedio de los mantenimientos
  final double averageCost;

  /// Servicios más frecuentes (nombre del servicio y cantidad de veces)
  final List<ServiceFrequency> mostFrequentServices;

  /// Lista detallada de todos los mantenimientos
  final List<MaintenanceDetail> maintenances;

  /// Fecha del último mantenimiento registrado
  final DateTime? lastMaintenanceDate;

  /// Rango de fechas del reporte (inicio)
  final DateTime? startDate;

  /// Rango de fechas del reporte (fin)
  final DateTime? endDate;

  const MaintenanceReportEntity({
    required this.totalMaintenances,
    required this.totalCost,
    required this.averageCost,
    required this.mostFrequentServices,
    this.maintenances = const [],
    this.lastMaintenanceDate,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [
    totalMaintenances,
    totalCost,
    averageCost,
    mostFrequentServices,
    maintenances,
    lastMaintenanceDate,
    startDate,
    endDate,
  ];
}

/// Representa el detalle de un mantenimiento individual
class MaintenanceDetail extends Equatable {
  final int id;
  final int motoId;
  final DateTime fecha;
  final String tipo;
  final String? descripcion;
  final int? kilometraje;
  final double costo;

  const MaintenanceDetail({
    required this.id,
    required this.motoId,
    required this.fecha,
    required this.tipo,
    this.descripcion,
    this.kilometraje,
    required this.costo,
  });

  @override
  List<Object?> get props => [
    id,
    motoId,
    fecha,
    tipo,
    descripcion,
    kilometraje,
    costo,
  ];
}

/// Representa la frecuencia de un servicio con estadísticas completas
class ServiceFrequency extends Equatable {
  final String serviceName;
  final int count;
  final double? totalCost;
  final double? averageCost;

  const ServiceFrequency({
    required this.serviceName,
    required this.count,
    this.totalCost,
    this.averageCost,
  });

  @override
  List<Object?> get props => [serviceName, count, totalCost, averageCost];
}
