import '../repositories/maintenance_report_repository.dart';

/// Caso de uso para exportar el reporte a PDF
class ExportReportToPdf {
  final MaintenanceReportRepository repository;

  ExportReportToPdf(this.repository);

  /// Ejecuta el caso de uso para exportar el reporte
  /// Retorna la ruta del archivo PDF generado
  Future<String> call({
    DateTime? startDate,
    DateTime? endDate,
    String? motorcycleId,
  }) async {
    return await repository.exportReportToPdf(
      startDate: startDate,
      endDate: endDate,
      motorcycleId: motorcycleId,
    );
  }
}
