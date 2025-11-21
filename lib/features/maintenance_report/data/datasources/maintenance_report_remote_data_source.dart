import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/network/api_config.dart';
import '../../../../core/services/auth_storage_service.dart';
import '../models/maintenance_report_model.dart';

/// Data source remoto para obtener reportes de mantenimiento
abstract class MaintenanceReportRemoteDataSource {
  /// Obtiene el reporte de mantenimientos desde el backend
  Future<MaintenanceReportModel> getMaintenanceReport({
    DateTime? startDate,
    DateTime? endDate,
    String? motorcycleId,
  });

  /// Solicita al backend que genere y devuelva el PDF
  Future<String> exportReportToPdf({
    DateTime? startDate,
    DateTime? endDate,
    String? motorcycleId,
  });
}

class MaintenanceReportRemoteDataSourceImpl
    implements MaintenanceReportRemoteDataSource {
  final http.Client client;
  final AuthStorageService authStorage;

  MaintenanceReportRemoteDataSourceImpl({
    http.Client? client,
    AuthStorageService? authStorage,
  }) : client = client ?? http.Client(),
       authStorage = authStorage ?? AuthStorageService();

  @override
  Future<MaintenanceReportModel> getMaintenanceReport({
    DateTime? startDate,
    DateTime? endDate,
    String? motorcycleId,
  }) async {
    try {
      print('🔍 [MaintenanceReport] Iniciando solicitud de reporte...');
      final token = await authStorage.getToken();
      if (token == null) {
        print('❌ [MaintenanceReport] No hay token de autenticación');
        throw Exception('No hay token de autenticación');
      }
      print('✅ [MaintenanceReport] Token obtenido');

      // Construir query parameters - solo incluir parámetros con valores válidos
      final queryParams = <String, String>{};
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }
      // Solo agregar motorcycleId si no está vacío
      if (motorcycleId != null && motorcycleId.isNotEmpty) {
        queryParams['motorcycleId'] = motorcycleId;
      }

      final uri = Uri.parse(
        '${ApiConfig.baseUrl}/maintenance/report',
      ).replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

      print('📡 [MaintenanceReport] URL: $uri');
      print(
        '🔑 [MaintenanceReport] Headers: ${ApiConfig.getAuthHeaders(token)}',
      );

      final response = await client
          .get(uri, headers: ApiConfig.getAuthHeaders(token))
          .timeout(ApiConfig.receiveTimeout);

      print('📨 [MaintenanceReport] Status Code: ${response.statusCode}');
      print('📦 [MaintenanceReport] Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('✅ [MaintenanceReport] Reporte parseado correctamente');
        return MaintenanceReportModel.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        // No hay datos, devolver reporte vacío
        print(
          '⚠️ [MaintenanceReport] No hay datos (404), devolviendo reporte vacío',
        );
        return const MaintenanceReportModel(
          totalMaintenances: 0,
          totalCost: 0.0,
          averageCost: 0.0,
          mostFrequentServices: [],
        );
      } else {
        print('❌ [MaintenanceReport] Error: ${response.statusCode}');
        throw Exception('Error al obtener el reporte: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 [MaintenanceReport] Exception: $e');
      throw Exception('Error al obtener el reporte: $e');
    }
  }

  @override
  Future<String> exportReportToPdf({
    DateTime? startDate,
    DateTime? endDate,
    String? motorcycleId,
  }) async {
    try {
      final token = await authStorage.getToken();
      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      // Construir query parameters - solo incluir parámetros con valores válidos
      final queryParams = <String, String>{};
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }
      // Solo agregar motorcycleId si no está vacío
      if (motorcycleId != null && motorcycleId.isNotEmpty) {
        queryParams['motorcycleId'] = motorcycleId;
      }

      final uri = Uri.parse(
        '${ApiConfig.baseUrl}/maintenance/report/pdf',
      ).replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

      final response = await client
          .get(uri, headers: ApiConfig.getAuthHeaders(token))
          .timeout(ApiConfig.receiveTimeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        // El backend debería devolver la URL o ruta del PDF generado
        return jsonData['pdfUrl'] ?? jsonData['url'] ?? '';
      } else {
        throw Exception('Error al exportar el reporte: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al exportar el reporte: $e');
    }
  }
}
