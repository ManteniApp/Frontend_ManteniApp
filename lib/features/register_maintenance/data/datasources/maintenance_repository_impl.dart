import 'package:frontend_manteniapp/features/register_maintenance/data/repositories/maintenance_remote_datasource.dart';
import 'package:frontend_manteniapp/features/register_maintenance/domain/entities/maintenance_entity.dart';
import 'package:frontend_manteniapp/features/register_maintenance/domain/repositories/maintenance_repository.dart';

class MaintenanceRepositoryImpl implements MaintenanceRepository {
  final MaintenanceRemoteDataSource remoteDataSource;

  MaintenanceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Maintenance> createMaintenance(Maintenance maintenance) {
    return remoteDataSource.createMaintenance(maintenance);
  }

  @override
  Future<List<Maintenance>> getMaintenancesByMoto(int motoId) {
    return remoteDataSource.getMaintenancesByMoto(motoId);
  }

  @override
  Future<Maintenance> getMaintenanceById(int id) {
    return remoteDataSource.getMaintenanceById(id);
  }

  @override
  Future<List<Maintenance>> getUpcomingMaintenances(int motoId) {
    return remoteDataSource.getUpcomingMaintenances(motoId);
  }

  @override
  Future<List<Maintenance>> getOilChangeRecords(int motoId) {
    return remoteDataSource.getOilChangeRecords(motoId);
  }

  @override
  Future<Map<String, dynamic>> getMaintenanceStats(int motoId) {
    return remoteDataSource.getMaintenanceStats(motoId);
  }

  @override
  Future<List<Maintenance>> getMaintenancesByDateRange(
      int motoId, DateTime startDate, DateTime endDate) {
    return remoteDataSource.getMaintenancesByDateRange(motoId, startDate, endDate);
  }

  @override
  Future<List<Maintenance>> getMaintenancesByType(int motoId, String tipo) {
    return remoteDataSource.getMaintenancesByType(motoId, tipo);
  }

  @override
  Future<List<Map<String, dynamic>>> getMaintenanceCostByMonth(
      int motoId, int? year) {
    return remoteDataSource.getMaintenanceCostByMonth(motoId, year);
  }

  @override
  Future<Maintenance> updateMaintenance(int id, Maintenance maintenance) {
    return remoteDataSource.updateMaintenance(id, maintenance);
  }

  @override
  Future<void> deleteMaintenance(int id) {
    return remoteDataSource.deleteMaintenance(id);
  }
}