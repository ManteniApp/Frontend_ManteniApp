import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/network/api_config.dart';
import '../../../../core/services/auth_storage_service.dart';
import '../models/recommendation_model.dart';

/// Data source remoto para recomendaciones de mantenimiento
abstract class RecommendationRemoteDataSource {
  /// Obtener todas las recomendaciones
  Future<List<MaintenanceRecommendationModel>> getAllRecommendations();

  /// Obtener recomendaciones técnicas
  Future<List<MaintenanceRecommendationModel>> getTechnicalRecommendations();

  /// Obtener recomendaciones generales
  Future<List<MaintenanceRecommendationModel>> getGeneralRecommendations();

  /// Obtener recomendaciones de seguridad
  Future<List<MaintenanceRecommendationModel>> getSafetyRecommendations();

  /// Obtener recomendaciones de rendimiento
  Future<List<MaintenanceRecommendationModel>> getPerformanceRecommendations();

  /// Obtener recomendaciones técnicas por tipo
  Future<List<MaintenanceRecommendationModel>> getTechnicalByType(String type);

  /// Obtener recomendaciones por categoría
  Future<List<MaintenanceRecommendationModel>> getRecommendationsByCategory(
    String category,
  );

  /// Obtener recomendaciones por prioridad
  Future<List<MaintenanceRecommendationModel>> getRecommendationsByPriority(
    String priority,
  );

  /// Obtener próximas recomendaciones
  Future<List<MaintenanceRecommendationModel>> getUpcomingRecommendations();

  /// Obtener recomendaciones por tipo de mantenimiento
  Future<List<MaintenanceRecommendationModel>>
  getRecommendationsByMaintenanceType(String type);

  /// Eliminar una recomendación
  Future<bool> deleteRecommendation(String id);

  // Métodos legacy para mantener compatibilidad
  @Deprecated('Usar getAllRecommendations() o getGeneralRecommendations()')
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

  /// Método auxiliar para hacer peticiones GET
  Future<List<MaintenanceRecommendationModel>> _getRecommendations(
    String endpoint,
  ) async {
    try {
      final token = await authStorage.getToken();
      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');

      final response = await client
          .get(uri, headers: ApiConfig.getAuthHeaders(token))
          .timeout(ApiConfig.receiveTimeout);

      if (response.statusCode == 200) {
        final dynamic decodedBody = json.decode(response.body);

        // Manejar diferentes formatos de respuesta
        List<dynamic> jsonData;

        if (decodedBody is List) {
          // Si es una lista directamente
          jsonData = decodedBody;
        } else if (decodedBody is Map) {
          // Si es un objeto, buscar la propiedad que contiene la lista
          // Intentar diferentes nombres comunes
          if (decodedBody.containsKey('data')) {
            jsonData = decodedBody['data'] as List<dynamic>;
          } else if (decodedBody.containsKey('recommendations')) {
            jsonData = decodedBody['recommendations'] as List<dynamic>;
          } else if (decodedBody.containsKey('results')) {
            jsonData = decodedBody['results'] as List<dynamic>;
          } else {
            // Si no encuentra ninguna propiedad conocida, devolver lista vacía
            jsonData = [];
          }
        } else {
          jsonData = [];
        }

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
  Future<List<MaintenanceRecommendationModel>> getAllRecommendations() async {
    return _getRecommendations('/recommendations');
  }

  @override
  Future<List<MaintenanceRecommendationModel>>
  getTechnicalRecommendations() async {
    return _getRecommendations('/recommendations/technical');
  }

  @override
  Future<List<MaintenanceRecommendationModel>>
  getGeneralRecommendations() async {
    return _getRecommendations('/recommendations/general');
  }

  @override
  Future<List<MaintenanceRecommendationModel>>
  getSafetyRecommendations() async {
    return _getRecommendations('/recommendations/safety');
  }

  @override
  Future<List<MaintenanceRecommendationModel>>
  getPerformanceRecommendations() async {
    return _getRecommendations('/recommendations/performance');
  }

  @override
  Future<List<MaintenanceRecommendationModel>> getTechnicalByType(
    String type,
  ) async {
    return _getRecommendations('/recommendations/technical/$type');
  }

  @override
  Future<List<MaintenanceRecommendationModel>> getRecommendationsByCategory(
    String category,
  ) async {
    return _getRecommendations('/recommendations/category/$category');
  }

  @override
  Future<List<MaintenanceRecommendationModel>> getRecommendationsByPriority(
    String priority,
  ) async {
    return _getRecommendations('/recommendations/priority/$priority');
  }

  @override
  Future<List<MaintenanceRecommendationModel>>
  getUpcomingRecommendations() async {
    return _getRecommendations('/recommendations/upcoming');
  }

  @override
  Future<List<MaintenanceRecommendationModel>>
  getRecommendationsByMaintenanceType(String type) async {
    return _getRecommendations('/recommendations/maintenance-type/$type');
  }

  @override
  Future<bool> deleteRecommendation(String id) async {
    try {
      final token = await authStorage.getToken();
      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      final uri = Uri.parse('${ApiConfig.baseUrl}/maintenance/$id');

      final response = await client
          .delete(uri, headers: ApiConfig.getAuthHeaders(token))
          .timeout(ApiConfig.receiveTimeout);

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      throw Exception('Error al eliminar recomendación: $e');
    }
  }

  @override
  @Deprecated('Usar getAllRecommendations() o getGeneralRecommendations()')
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
