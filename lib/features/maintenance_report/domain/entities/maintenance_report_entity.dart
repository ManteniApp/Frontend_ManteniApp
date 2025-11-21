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
    lastMaintenanceDate,
    startDate,
    endDate,
  ];
}

/// Representa la frecuencia de un servicio
class ServiceFrequency extends Equatable {
  final String serviceName;
  final int count;

  const ServiceFrequency({required this.serviceName, required this.count});

  @override
  List<Object?> get props => [serviceName, count];
}
