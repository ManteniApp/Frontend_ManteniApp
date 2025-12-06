import '../entities/maintenance_report_entity.dart';

/// Repositorio abstracto para operaciones de reporte de mantenimientos
abstract class MaintenanceReportRepository {
  /// Obtiene el reporte de mantenimientos con filtros opcionales
  ///
  /// [startDate] - Fecha de inicio para filtrar los mantenimientos
  /// [endDate] - Fecha de fin para filtrar los mantenimientos
  /// [motorcycleId] - ID de la motocicleta para filtrar (opcional)
  Future<MaintenanceReportEntity> getMaintenanceReport({
    DateTime? startDate,
    DateTime? endDate,
    String? motorcycleId,
  });

  /// Exporta el reporte a PDF y devuelve la ruta del archivo generado
  ///
  /// [startDate] - Fecha de inicio para filtrar los mantenimientos
  /// [endDate] - Fecha de fin para filtrar los mantenimientos
  /// [motorcycleId] - ID de la motocicleta para filtrar (opcional)
  Future<String> exportReportToPdf({
    DateTime? startDate,
    DateTime? endDate,
    String? motorcycleId,
  });
}
