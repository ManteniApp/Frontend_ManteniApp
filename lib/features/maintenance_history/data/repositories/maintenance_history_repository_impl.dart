import '../../domain/entities/maintenance_entity.dart';
import '../../domain/repositories/maintenance_history_repository.dart';
import '../datasources/maintenance_history_remote_data_source.dart';
import '../models/maintenance_model.dart';

class MaintenanceHistoryRepositoryImpl implements MaintenanceHistoryRepository {
  final MaintenanceHistoryRemoteDataSource remoteDataSource;

  MaintenanceHistoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<MaintenanceEntity>> getMaintenanceHistory({
    DateTime? startDate,
    DateTime? endDate,
    double? minPrice,
    double? maxPrice,
    String? motorcycleId,
  }) async {
    final models = await remoteDataSource.getMaintenanceHistory(
      startDate: startDate,
      endDate: endDate,
      minPrice: minPrice,
      maxPrice: maxPrice,
      motorcycleId: motorcycleId,
    );
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<MaintenanceEntity?> getMaintenanceById(String id) async {
    final model = await remoteDataSource.getMaintenanceById(id);
    return model?.toEntity();
  }

  @override
  Future<MaintenanceEntity> createMaintenance(
    MaintenanceEntity maintenance,
  ) async {
    // Por ahora no implementado
    throw UnimplementedError('Crear mantenimiento aún no implementado');
  }
}
