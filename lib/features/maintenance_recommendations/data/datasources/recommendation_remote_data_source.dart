import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/network/api_config.dart';
import '../../../../core/services/auth_storage_service.dart';
import '../models/recommendation_model.dart';

/// Data source remoto para recomendaciones de mantenimiento
abstract class RecommendationRemoteDataSource {
  Future<List<MaintenanceRecommendationModel>> getGeneralRecommendations();
  Future<List<MaintenanceRecommendationModel>> getRecommendationsForMotorcycle(
    String motorcycleId,
  );
}

class RecommendationRemoteDataSourceImpl
    implements RecommendationRemoteDataSource {
  final http.Client client;
  final AuthStorageService authStorage;

  RecommendationRemoteDataSourceImpl({
    http.Client? client,
    AuthStorageService? authStorage,
  }) : client = client ?? http.Client(),
       authStorage = authStorage ?? AuthStorageService();

  @override
  Future<List<MaintenanceRecommendationModel>>
  getGeneralRecommendations() async {
    try {
      final token = await authStorage.getToken();
      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      final uri = Uri.parse(
        '${ApiConfig.baseUrl}/maintenance/recommendations/general',
      );

      final response = await client
          .get(uri, headers: ApiConfig.getAuthHeaders(token))
          .timeout(ApiConfig.receiveTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData
            .map((json) => MaintenanceRecommendationModel.fromJson(json))
            .toList();
      } else if (response.statusCode == 404) {
        // No hay recomendaciones, devolver lista vacía
        return [];
      } else {
        throw Exception(
          'Error al obtener recomendaciones: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error al obtener recomendaciones: $e');
    }
  }

  @override
  Future<List<MaintenanceRecommendationModel>> getRecommendationsForMotorcycle(
    String motorcycleId,
  ) async {
    try {
      final token = await authStorage.getToken();
      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      final uri = Uri.parse(
        '${ApiConfig.baseUrl}/motorcycles/$motorcycleId/maintenance-recommendations',
      );

      final response = await client
          .get(uri, headers: ApiConfig.getAuthHeaders(token))
          .timeout(ApiConfig.receiveTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData
            .map((json) => MaintenanceRecommendationModel.fromJson(json))
            .toList();
      } else if (response.statusCode == 404) {
        // No hay recomendaciones específicas, devolver lista vacía
        return [];
      } else {
        throw Exception(
          'Error al obtener recomendaciones: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error al obtener recomendaciones: $e');
    }
  }
}
