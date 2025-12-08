import '../entities/maintenance_entity.dart';
import '../repositories/maintenance_history_repository.dart';

/// Caso de uso para actualizar un mantenimiento existente
class UpdateMaintenance {
  final MaintenanceHistoryRepository repository;

  UpdateMaintenance(this.repository);

  /// Ejecuta la actualización del mantenimiento
  Future<MaintenanceEntity> call(MaintenanceEntity maintenance) async {
    if (maintenance.id == null || maintenance.id!.isEmpty) {
      throw ArgumentError('El ID del mantenimiento no puede estar vacío');
    }

    return await repository.updateMaintenance(maintenance);
  }
}
