import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;
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

      // Las fechas son OPCIONALES - el backend funciona sin ellas
      // Si se proporcionan, se usan como filtros
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String().split('T')[0];
      }

      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String().split('T')[0];
      }

      // El parámetro 'tipo' es opcional
      // Si no se envía, el backend devuelve todos los tipos
      // queryParams['tipo'] = 'Cambio de aceite'; // Omitido para obtener todos

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
      print('📄 [PDF Export] Iniciando exportación de PDF...');

      final token = await authStorage.getToken();
      if (token == null) {
        throw Exception('No hay token de autenticación');
      }
      print('✅ [PDF Export] Token obtenido');

      // Construir query parameters según la API del backend
      final queryParams = <String, String>{};

      // motoId es requerido según el Swagger
      if (motorcycleId != null && motorcycleId.isNotEmpty) {
        queryParams['motoId'] = motorcycleId;
      } else {
        throw Exception('motoId es requerido para exportar PDF');
      }

      // Los demás parámetros son opcionales según probamos en Swagger
      // Solo los incluimos si el usuario los ha especificado
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String().split('T')[0];
      }

      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String().split('T')[0];
      }

      // tipo es opcional - si no se especifica, el backend incluye todos
      if (startDate != null || endDate != null) {
        queryParams['tipo'] = 'todos';
      }

      final uri = Uri.parse(
        '${ApiConfig.baseUrl}${ApiConfig.maintenanceSummaryPdfEndpoint}',
      ).replace(queryParameters: queryParams);

      print('📡 [PDF Export] URL: $uri');

      final response = await client
          .get(
            uri,
            headers: {
              'Accept': 'application/pdf, */*',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(ApiConfig.receiveTimeout);

      print('📨 [PDF Export] Status Code: ${response.statusCode}');
      print(
        '📨 [PDF Export] Content-Type: ${response.headers['content-type']}',
      );

      if (response.statusCode == 200) {
        print('✅ [PDF Export] PDF recibido, iniciando descarga...');

        // Generar un nombre de archivo con timestamp
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final filename = 'reporte-mantenimientos-$timestamp.pdf';

        // Obtener los bytes del PDF
        final bytes = response.bodyBytes;

        if (kIsWeb) {
          // ============== FLUTTER WEB ==============
          print('📱 [PDF Export] Plataforma: Web');

          // Crear un blob con los datos del PDF
          final blob = html.Blob([bytes], 'application/pdf');

          // Crear una URL del blob
          final url = html.Url.createObjectUrlFromBlob(blob);

          // Crear un elemento anchor y simular el click para descargar
          final anchor = html.AnchorElement(href: url)
            ..setAttribute('download', filename)
            ..style.display = 'none';

          html.document.body?.append(anchor);
          anchor.click();

          // Limpiar
          anchor.remove();
          html.Url.revokeObjectUrl(url);

          print('✅ [PDF Export] Descarga iniciada (Web): $filename');
          return filename;
        } else {
          // ============== ANDROID / iOS ==============
          print('📱 [PDF Export] Plataforma: Móvil');

          // Obtener el directorio de descargas
          Directory? directory;

          if (Platform.isAndroid) {
            // Para Android, intentar usar el directorio de descargas público
            directory = Directory('/storage/emulated/0/Download');
            if (!await directory.exists()) {
              // Fallback al directorio de documentos de la app
              directory = await getApplicationDocumentsDirectory();
            }
          } else if (Platform.isIOS) {
            // Para iOS, usar el directorio de documentos de la app
            directory = await getApplicationDocumentsDirectory();
          } else {
            // Fallback para otras plataformas
            directory = await getApplicationDocumentsDirectory();
          }

          // Crear el archivo
          final filePath = '${directory.path}/$filename';
          final file = File(filePath);
          await file.writeAsBytes(bytes);

          print('✅ [PDF Export] Archivo guardado en: $filePath');

          // Retornar la ruta completa del archivo
          return filePath;
        }
      } else {
        final errorBody = response.body;
        print('❌ [PDF Export] Error: ${response.statusCode}');
        print('❌ [PDF Export] Body: $errorBody');
        throw Exception(
          'Error al exportar el reporte: ${response.statusCode} - $errorBody',
        );
      }
    } catch (e) {
      print('❌ [PDF Export] Excepción: $e');
      throw Exception('Error al exportar el reporte: $e');
    }
  }
}
