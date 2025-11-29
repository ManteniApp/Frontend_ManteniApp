
import 'package:frontend_manteniapp/features/register_maintenance/domain/entities/maintenance_entity.dart';

abstract class MaintenanceRepository {
  Future<Maintenance> createMaintenance(Maintenance maintenance);
  Future<List<Maintenance>> getMaintenancesByMoto(int motoId);
  Future<Maintenance> getMaintenanceById(int id);
  Future<List<Maintenance>> getUpcomingMaintenances(int motoId);
  Future<List<Maintenance>> getOilChangeRecords(int motoId);
  Future<Map<String, dynamic>> getMaintenanceStats(int motoId);
  Future<List<Maintenance>> getMaintenancesByDateRange(
      int motoId, DateTime startDate, DateTime endDate);
  Future<List<Maintenance>> getMaintenancesByType(int motoId, String tipo);
  Future<List<Map<String, dynamic>>> getMaintenanceCostByMonth(
      int motoId, int? year);
  Future<Maintenance> updateMaintenance(int id, Maintenance maintenance);
  Future<void> deleteMaintenance(int id);
}