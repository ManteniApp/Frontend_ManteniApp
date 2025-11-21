import '../../domain/entities/maintenance_report_entity.dart';
import '../../domain/repositories/maintenance_report_repository.dart';
import '../datasources/maintenance_report_remote_data_source.dart';

/// Implementación del repositorio de reportes de mantenimiento
class MaintenanceReportRepositoryImpl implements MaintenanceReportRepository {
  final MaintenanceReportRemoteDataSource remoteDataSource;

  MaintenanceReportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<MaintenanceReportEntity> getMaintenanceReport({
    DateTime? startDate,
    DateTime? endDate,
    String? motorcycleId,
  }) async {
    try {
      return await remoteDataSource.getMaintenanceReport(
        startDate: startDate,
        endDate: endDate,
        motorcycleId: motorcycleId,
      );
    } catch (e) {
      throw Exception('Error al obtener el reporte: $e');
    }
  }

  @override
  Future<String> exportReportToPdf({
    DateTime? startDate,
    DateTime? endDate,
    String? motorcycleId,
  }) async {
    try {
      return await remoteDataSource.exportReportToPdf(
        startDate: startDate,
        endDate: endDate,
        motorcycleId: motorcycleId,
      );
    } catch (e) {
      throw Exception('Error al exportar el reporte: $e');
    }
  }
}
