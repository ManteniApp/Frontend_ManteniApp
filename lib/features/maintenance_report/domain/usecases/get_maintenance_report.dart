import '../entities/maintenance_report_entity.dart';
import '../repositories/maintenance_report_repository.dart';

/// Caso de uso para obtener el reporte de mantenimientos
class GetMaintenanceReport {
  final MaintenanceReportRepository repository;

  GetMaintenanceReport(this.repository);

  /// Ejecuta el caso de uso para obtener el reporte
  Future<MaintenanceReportEntity> call({
    DateTime? startDate,
    DateTime? endDate,
    String? motorcycleId,
  }) async {
    return await repository.getMaintenanceReport(
      startDate: startDate,
      endDate: endDate,
      motorcycleId: motorcycleId,
    );
  }
}
