import 'package:dio/dio.dart';
import 'package:frontend_manteniapp/features/register_maintenance/domain/entities/maintenance_entity.dart';

abstract class MaintenanceRemoteDataSource {
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

class MaintenanceRemoteDataSourceImpl implements MaintenanceRemoteDataSource {
  final Dio dio;

  MaintenanceRemoteDataSourceImpl({required this.dio});

  @override
  Future<Maintenance> createMaintenance(Maintenance maintenance) async {
    try{
      print('🌐 DataSource - Enviando mantenimiento al servidor...');
      print('   - Costo a enviar: ${maintenance.costo} (${maintenance.costo?.runtimeType})');
      
      final response = await dio.post(
        '/maintenance',
        data: maintenance.toJson(),
      );
      print('✅ DataSource - Respuesta recibida: ${response.statusCode}');
        return Maintenance.fromJson(response.data);
      } catch (e) {
        print('❌ DataSource - Error: $e');
        rethrow;
      }
    }

  @override
  Future<List<Maintenance>> getMaintenancesByMoto(int motoId) async {
    final response = await dio.get('/maintenance/$motoId');
    return (response.data as List)
        .map((json) => Maintenance.fromJson(json))
        .toList();
  }

  @override
  Future<Maintenance> getMaintenanceById(int id) async {
    final response = await dio.get('/maintenance/detail/$id');
    return Maintenance.fromJson(response.data);
  }

  @override
  Future<List<Maintenance>> getUpcomingMaintenances(int motoId) async {
    final response = await dio.get('/maintenance/upcoming/$motoId');
    return (response.data as List)
        .map((json) => Maintenance.fromJson(json))
        .toList();
  }

  @override
  Future<List<Maintenance>> getOilChangeRecords(int motoId) async {
    final response = await dio.get('/maintenance/oil-changes/$motoId');
    return (response.data as List)
        .map((json) => Maintenance.fromJson(json))
        .toList();
  }

  @override
  Future<Map<String, dynamic>> getMaintenanceStats(int motoId) async {
    final response = await dio.get('/maintenance/stats/$motoId');
    return response.data;
  }

  @override
  Future<List<Maintenance>> getMaintenancesByDateRange(
      int motoId, DateTime startDate, DateTime endDate) async {
    final response = await dio.get(
      '/maintenance/date-range/$motoId',
      queryParameters: {
        'startDate': startDate.toIso8601String().split('T')[0],
        'endDate': endDate.toIso8601String().split('T')[0],
      },
    );
    return (response.data as List)
        .map((json) => Maintenance.fromJson(json))
        .toList();
  }

  @override
  Future<List<Maintenance>> getMaintenancesByType(int motoId, String tipo) async {
    final response = await dio.get(
      '/maintenance/type/$motoId',
      queryParameters: {'tipo': tipo},
    );
    return (response.data as List)
        .map((json) => Maintenance.fromJson(json))
        .toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getMaintenanceCostByMonth(
      int motoId, int? year) async {
    final response = await dio.get(
      '/maintenance/cost-monthly/$motoId',
      queryParameters: year != null ? {'year': year} : null,
    );
    return List<Map<String, dynamic>>.from(response.data);
  }

  @override
  Future<Maintenance> updateMaintenance(int id, Maintenance maintenance) async {
    final response = await dio.put(
      '/maintenance/$id',
      data: maintenance.toJson(),
    );
    return Maintenance.fromJson(response.data);
  }

  @override
  Future<void> deleteMaintenance(int id) async {
    await dio.delete('/maintenance/$id');
  }
}