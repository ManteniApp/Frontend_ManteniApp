import '../../domain/entities/maintenance_report_entity.dart';
import '../../domain/repositories/maintenance_report_repository.dart';
import '../datasources/maintenance_report_remote_data_source.dart';
import '../datasources/maintenance_report_mock_data_source.dart';

/// ⚠️ CONFIGURACIÓN: Cambiar a false cuando el backend esté listo
const bool USE_MOCK_DATA = false;

/// Implementación del repositorio de reportes de mantenimiento
class MaintenanceReportRepositoryImpl implements MaintenanceReportRepository {
  final MaintenanceReportRemoteDataSource? remoteDataSource;
  final MaintenanceReportMockDataSource? mockDataSource;

  MaintenanceReportRepositoryImpl({this.remoteDataSource, this.mockDataSource})
    : assert(
        remoteDataSource != null || mockDataSource != null,
        'Debe proporcionar al menos un data source',
      );

  @override
  Future<MaintenanceReportEntity> getMaintenanceReport({
    DateTime? startDate,
    DateTime? endDate,
    String? motorcycleId,
  }) async {
    try {
      if (USE_MOCK_DATA) {
        print('🎭 [Repository] Usando datos MOCK');
        final mock = mockDataSource ?? MaintenanceReportMockDataSource();
        return await mock.getMaintenanceReport(
          startDate: startDate,
          endDate: endDate,
          motorcycleId: motorcycleId,
        );
      } else {
        print('📡 [Repository] Usando datos REALES del backend');
        return await remoteDataSource!.getMaintenanceReport(
          startDate: startDate,
          endDate: endDate,
          motorcycleId: motorcycleId,
        );
      }
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
      if (USE_MOCK_DATA) {
        print('🎭 [Repository] Exportando PDF MOCK');
        final mock = mockDataSource ?? MaintenanceReportMockDataSource();
        return await mock.exportReportToPdf(
          startDate: startDate,
          endDate: endDate,
          motorcycleId: motorcycleId,
        );
      } else {
        print('📡 [Repository] Exportando PDF REAL del backend');
        return await remoteDataSource!.exportReportToPdf(
          startDate: startDate,
          endDate: endDate,
          motorcycleId: motorcycleId,
        );
      }
    } catch (e) {
      throw Exception('Error al exportar el reporte: $e');
    }
  }
}
