import 'dart:convert';
import '../models/maintenance_model.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_config.dart';

abstract class MaintenanceHistoryRemoteDataSource {
  Future<List<MaintenanceModel>> getMaintenanceHistory({
    DateTime? startDate,
    DateTime? endDate,
    double? minPrice,
    double? maxPrice,
    String? motorcycleId,
  });

  Future<MaintenanceModel?> getMaintenanceById(String id);

  Future<MaintenanceModel> createMaintenance(MaintenanceModel maintenance);

  Future<MaintenanceModel> updateMaintenance(
    String id,
    MaintenanceModel maintenance,
  );

  Future<void> deleteMaintenance(String id);
}

class MaintenanceHistoryRemoteDataSourceImpl
    implements MaintenanceHistoryRemoteDataSource {
  final ApiClient apiClient;

  MaintenanceHistoryRemoteDataSourceImpl({ApiClient? apiClient})
    : apiClient = apiClient ?? ApiClient();

  @override
  Future<List<MaintenanceModel>> getMaintenanceHistory({
    DateTime? startDate,
    DateTime? endDate,
    double? minPrice,
    double? maxPrice,
    String? motorcycleId,
  }) async {
    try {
      // El motorcycleId es REQUERIDO según el backend
      if (motorcycleId == null || motorcycleId.isEmpty) {
        // Si no hay moto seleccionada, retornar lista vacía
        return [];
      }

      // Construir URL con el ID de la moto en la ruta
      final url = '${ApiConfig.maintenanceHistoryEndpoint}/$motorcycleId';

      final response = await apiClient.get(url, requiresAuth: true);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => MaintenanceModel.fromJson(json)).toList();
      } else {
        throw Exception(
          'Error al obtener historial de mantenimientos: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  @override
  Future<MaintenanceModel?> getMaintenanceById(String id) async {
    try {
      final response = await apiClient.get(
        '${ApiConfig.maintenanceHistoryEndpoint}/$id',
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return MaintenanceModel.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception(
          'Error al obtener mantenimiento: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  @override
  Future<MaintenanceModel> createMaintenance(
    MaintenanceModel maintenance,
  ) async {
    try {
      final response = await apiClient.post(
        ApiConfig.maintenanceHistoryEndpoint,
        body: maintenance.toJson(),
        requiresAuth: true,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return MaintenanceModel.fromJson(jsonData);
      } else {
        throw Exception(
          'Error al crear mantenimiento: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  @override
  Future<MaintenanceModel> updateMaintenance(
    String id,
    MaintenanceModel maintenance,
  ) async {
    try {
      final response = await apiClient.put(
        '${ApiConfig.maintenanceHistoryEndpoint}/$id',
        body: maintenance
            .toUpdateJson(), // ⚠️ Solo campos permitidos: precio, descripcion
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return MaintenanceModel.fromJson(jsonData);
      } else {
        throw Exception(
          'Error al actualizar mantenimiento: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  @override
  Future<void> deleteMaintenance(String id) async {
    try {
      final response = await apiClient.delete(
        '${ApiConfig.maintenanceHistoryEndpoint}/$id',
        requiresAuth: true,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
          'Error al eliminar mantenimiento: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
