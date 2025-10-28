import '../repositories/maintenance_history_repository.dart';

/// Caso de uso para eliminar un mantenimiento
class DeleteMaintenance {
  final MaintenanceHistoryRepository repository;

  DeleteMaintenance(this.repository);

  /// Ejecuta la eliminación del mantenimiento
  Future<void> call(String id) async {
    if (id.isEmpty) {
      throw ArgumentError('El ID del mantenimiento no puede estar vacío');
    }

    await repository.deleteMaintenance(id);
  }
}
