import '../entities/maintenance_entity.dart';
import '../repositories/maintenance_history_repository.dart';

/// Caso de uso para obtener el historial de mantenimientos con filtros
class GetMaintenanceHistory {
  final MaintenanceHistoryRepository repository;

  GetMaintenanceHistory(this.repository);

  Future<List<MaintenanceEntity>> call({
    DateTime? startDate,
    DateTime? endDate,
    double? minPrice,
    double? maxPrice,
    String? motorcycleId,
  }) async {
    return await repository.getMaintenanceHistory(
      startDate: startDate,
      endDate: endDate,
      minPrice: minPrice,
      maxPrice: maxPrice,
      motorcycleId: motorcycleId,
    );
  }
}
