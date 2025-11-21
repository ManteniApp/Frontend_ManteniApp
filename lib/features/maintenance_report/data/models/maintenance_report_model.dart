import '../../domain/entities/maintenance_report_entity.dart';

/// Modelo de datos para el reporte de mantenimientos
class MaintenanceReportModel extends MaintenanceReportEntity {
  const MaintenanceReportModel({
    required super.totalMaintenances,
    required super.totalCost,
    required super.averageCost,
    required super.mostFrequentServices,
    super.lastMaintenanceDate,
    super.startDate,
    super.endDate,
  });

  /// Helper para parsear valores numéricos
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Crea un modelo desde JSON
  factory MaintenanceReportModel.fromJson(Map<String, dynamic> json) {
    // Parsear servicios más frecuentes
    final servicesJson = json['mostFrequentServices'] as List<dynamic>? ?? [];
    final services = servicesJson
        .map((service) => ServiceFrequencyModel.fromJson(service))
        .toList();

    return MaintenanceReportModel(
      totalMaintenances: json['totalMaintenances'] ?? 0,
      totalCost: _parseDouble(json['totalCost']),
      averageCost: _parseDouble(json['averageCost']),
      mostFrequentServices: services,
      lastMaintenanceDate: json['lastMaintenanceDate'] != null
          ? DateTime.parse(json['lastMaintenanceDate'])
          : null,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
    );
  }

  /// Convierte el modelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'totalMaintenances': totalMaintenances,
      'totalCost': totalCost,
      'averageCost': averageCost,
      'mostFrequentServices': mostFrequentServices
          .map((s) => (s as ServiceFrequencyModel).toJson())
          .toList(),
      'lastMaintenanceDate': lastMaintenanceDate?.toIso8601String(),
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }
}

/// Modelo para la frecuencia de servicios
class ServiceFrequencyModel extends ServiceFrequency {
  const ServiceFrequencyModel({
    required super.serviceName,
    required super.count,
  });

  factory ServiceFrequencyModel.fromJson(Map<String, dynamic> json) {
    return ServiceFrequencyModel(
      serviceName: json['serviceName'] ?? json['name'] ?? '',
      count: json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'serviceName': serviceName, 'count': count};
  }
}
