import '../../domain/entities/maintenance_report_entity.dart';

/// Modelo de datos para el reporte de mantenimientos
class MaintenanceReportModel extends MaintenanceReportEntity {
  const MaintenanceReportModel({
    required super.totalMaintenances,
    required super.totalCost,
    required super.averageCost,
    required super.mostFrequentServices,
    super.maintenances = const [],
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
    // Parsear servicios más frecuentes (mapeando desde español)
    final servicesJson =
        json['estadisticasPorTipo'] as List<dynamic>? ??
        json['mostFrequentServices'] as List<dynamic>? ??
        [];
    final services = servicesJson
        .map((service) => ServiceFrequencyModel.fromJson(service))
        .toList();

    // Parsear lista de mantenimientos
    final maintenancesJson = json['mantenimientos'] as List<dynamic>? ?? [];
    final maintenances = maintenancesJson
        .map((m) => MaintenanceDetailModel.fromJson(m))
        .toList();

    print('📅 [Model] Total mantenimientos parseados: ${maintenances.length}');

    // Calcular la última fecha de mantenimiento desde la lista
    DateTime? lastMaintenanceDate;
    if (json['lastMaintenanceDate'] != null) {
      lastMaintenanceDate = DateTime.parse(json['lastMaintenanceDate']);
      print('📅 [Model] Fecha del backend: $lastMaintenanceDate');
    } else if (maintenances.isNotEmpty) {
      // Si no viene del backend, ordenar por fecha descendente y tomar la primera
      final sortedMaintenances = List<MaintenanceDetailModel>.from(maintenances)
        ..sort((a, b) => b.fecha.compareTo(a.fecha));

      lastMaintenanceDate = sortedMaintenances.first.fecha;

      print('📅 [Model] Fechas de mantenimientos:');
      for (var m in sortedMaintenances.take(3)) {
        print('   - ${m.fecha.toIso8601String()} (${m.tipo})');
      }
      print('📅 [Model] Última fecha calculada: $lastMaintenanceDate');
    } else {
      print('⚠️ [Model] No hay mantenimientos para calcular última fecha');
    }

    return MaintenanceReportModel(
      totalMaintenances:
          json['totalMantenimientos'] ?? json['totalMaintenances'] ?? 0,
      totalCost: _parseDouble(json['costoTotal'] ?? json['totalCost']),
      averageCost: _parseDouble(json['costoPromedio'] ?? json['averageCost']),
      mostFrequentServices: services,
      maintenances: maintenances,
      lastMaintenanceDate: lastMaintenanceDate,
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
      'maintenances': maintenances
          .map((m) => (m as MaintenanceDetailModel).toJson())
          .toList(),
      'lastMaintenanceDate': lastMaintenanceDate?.toIso8601String(),
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }
}

/// Modelo para el detalle de un mantenimiento
class MaintenanceDetailModel extends MaintenanceDetail {
  const MaintenanceDetailModel({
    required super.id,
    required super.motoId,
    required super.fecha,
    required super.tipo,
    super.descripcion,
    super.kilometraje,
    required super.costo,
  });

  factory MaintenanceDetailModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceDetailModel(
      id: json['id'] ?? 0,
      motoId: json['moto_id'] ?? json['motoId'] ?? 0,
      fecha: DateTime.parse(json['fecha']),
      tipo: json['tipo'] ?? '',
      descripcion: json['descripcion'],
      kilometraje: json['kilometraje'],
      costo: MaintenanceReportModel._parseDouble(json['costo']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'moto_id': motoId,
      'fecha': fecha.toIso8601String(),
      'tipo': tipo,
      'descripcion': descripcion,
      'kilometraje': kilometraje,
      'costo': costo,
    };
  }
}

/// Modelo para la frecuencia de servicios
class ServiceFrequencyModel extends ServiceFrequency {
  const ServiceFrequencyModel({
    required super.serviceName,
    required super.count,
    super.totalCost,
    super.averageCost,
  });

  factory ServiceFrequencyModel.fromJson(Map<String, dynamic> json) {
    return ServiceFrequencyModel(
      serviceName: json['tipo'] ?? json['serviceName'] ?? json['name'] ?? '',
      count: json['cantidad'] ?? json['count'] ?? 0,
      totalCost: MaintenanceReportModel._parseDouble(
        json['costoTotal'] ?? json['totalCost'],
      ),
      averageCost: MaintenanceReportModel._parseDouble(
        json['costoPromedio'] ?? json['averageCost'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceName': serviceName,
      'count': count,
      'totalCost': totalCost,
      'averageCost': averageCost,
    };
  }
}
