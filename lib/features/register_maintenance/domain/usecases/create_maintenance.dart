import 'package:frontend_manteniapp/features/register_maintenance/domain/entities/maintenance_entity.dart';
import 'package:frontend_manteniapp/features/register_maintenance/domain/repositories/maintenance_repository.dart';

class CreateMaintenanceUseCase {
  final MaintenanceRepository repository;

  CreateMaintenanceUseCase(this.repository);

  Future<Maintenance> execute(Maintenance maintenance) {
    return repository.createMaintenance(maintenance);
  }
}