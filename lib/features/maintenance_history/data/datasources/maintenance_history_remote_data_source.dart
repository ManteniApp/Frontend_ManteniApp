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
      // Construir query parameters
      final queryParams = <String, String>{};

      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }
      if (minPrice != null) {
        queryParams['minPrice'] = minPrice.toString();
      }
      if (maxPrice != null) {
        queryParams['maxPrice'] = maxPrice.toString();
      }
      if (motorcycleId != null) {
        queryParams['motorcycleId'] = motorcycleId;
      }

      // Construir URL con query params
      var url = ApiConfig.maintenanceHistoryEndpoint;
      if (queryParams.isNotEmpty) {
        final query = queryParams.entries
            .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
            .join('&');
        url = '$url?$query';
      }

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
}
