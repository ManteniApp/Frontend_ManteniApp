import '../entities/maintenance_entity.dart';

/// Repositorio para gestionar el historial de mantenimientos
abstract class MaintenanceHistoryRepository {
  /// Obtiene todos los mantenimientos con filtros opcionales
  Future<List<MaintenanceEntity>> getMaintenanceHistory({
    DateTime? startDate,
    DateTime? endDate,
    double? minPrice,
    double? maxPrice,
    String? motorcycleId,
  });

  /// Obtiene un mantenimiento por su ID
  Future<MaintenanceEntity?> getMaintenanceById(String id);

  /// Registra un nuevo mantenimiento
  Future<MaintenanceEntity> createMaintenance(MaintenanceEntity maintenance);
}
