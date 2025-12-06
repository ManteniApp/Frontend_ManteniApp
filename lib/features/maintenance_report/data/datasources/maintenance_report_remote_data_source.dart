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

      // Construir query parameters según la API del backend
      final queryParams = <String, String>{};

      // motoId es requerido según la API
      if (motorcycleId != null && motorcycleId.isNotEmpty) {
        queryParams['motoId'] = motorcycleId;
      } else {
        throw Exception('motoId es requerido');
      }

      // startDate es requerido
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String().split('T')[0];
      } else {
        throw Exception('startDate es requerido');
      }

      // endDate es requerido
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String().split('T')[0];
      } else {
        throw Exception('endDate es requerido');
      }

      // tipo es requerido (puede ser 'preventivo', 'correctivo', o 'todos')
      queryParams['tipo'] = 'todos';

      final uri = Uri.parse(
        '${ApiConfig.baseUrl}${ApiConfig.maintenanceSummaryEndpoint}',
      ).replace(queryParameters: queryParams);

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
      } else if (response.statusCode == 404 || response.statusCode == 400) {
        // No hay datos (404) o no se encontraron mantenimientos con los filtros (400)
        // Devolver reporte vacío en lugar de error
        print(
          '⚠️ [MaintenanceReport] No hay datos (${response.statusCode}), devolviendo reporte vacío',
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

      // Construir query parameters según la API del backend
      final queryParams = <String, String>{};

      // motoId es requerido según la API
      if (motorcycleId != null && motorcycleId.isNotEmpty) {
        queryParams['motoId'] = motorcycleId;
      } else {
        throw Exception('motoId es requerido');
      }

      // startDate es requerido
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String().split('T')[0];
      } else {
        throw Exception('startDate es requerido');
      }

      // endDate es requerido
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String().split('T')[0];
      } else {
        throw Exception('endDate es requerido');
      }

      // tipo es requerido (puede ser 'preventivo', 'correctivo', o 'todos')
      queryParams['tipo'] = 'todos';

      final uri = Uri.parse(
        '${ApiConfig.baseUrl}${ApiConfig.maintenanceSummaryPdfEndpoint}',
      ).replace(queryParameters: queryParams);

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
