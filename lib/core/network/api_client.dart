import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_config.dart';
import '../services/auth_storage_service.dart';

/// Cliente HTTP personalizado que maneja automáticamente:
/// - Headers de autenticación
/// - Manejo de errores
/// - Timeouts
/// - Logging en modo debug
class ApiClient {
  final http.Client _client;
  final AuthStorageService _authStorage;

  ApiClient({http.Client? client, AuthStorageService? authStorage})
    : _client = client ?? http.Client(),
      _authStorage = authStorage ?? AuthStorageService();

  /// GET request con autenticación automática
  Future<http.Response> get(
    String endpoint, {
    Map<String, String>? headers,
    bool requiresAuth = true,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final allHeaders = await _buildHeaders(headers, requiresAuth);

    _logRequest('GET', uri, allHeaders);

    try {
      final response = await _client
          .get(uri, headers: allHeaders)
          .timeout(ApiConfig.connectionTimeout);

      _logResponse(response);
      return response;
    } catch (e) {
      _logError('GET', uri, e);
      rethrow;
    }
  }

  /// POST request con autenticación automática
  Future<http.Response> post(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
    bool requiresAuth = true,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final allHeaders = await _buildHeaders(headers, requiresAuth);

    _logRequest('POST', uri, allHeaders, body);

    try {
      final response = await _client
          .post(
            uri,
            headers: allHeaders,
            body: body != null ? json.encode(body) : null,
          )
          .timeout(ApiConfig.connectionTimeout);

      _logResponse(response);
      return response;
    } catch (e) {
      _logError('POST', uri, e);
      rethrow;
    }
  }

  /// PUT request con autenticación automática
  Future<http.Response> put(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
    bool requiresAuth = true,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final allHeaders = await _buildHeaders(headers, requiresAuth);

    _logRequest('PUT', uri, allHeaders, body);

    try {
      final response = await _client
          .put(
            uri,
            headers: allHeaders,
            body: body != null ? json.encode(body) : null,
          )
          .timeout(ApiConfig.connectionTimeout);

      _logResponse(response);
      return response;
    } catch (e) {
      _logError('PUT', uri, e);
      rethrow;
    }
  }

  /// PATCH request con autenticación automática
  Future<http.Response> patch(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
    bool requiresAuth = true,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final allHeaders = await _buildHeaders(headers, requiresAuth);

    _logRequest('PATCH', uri, allHeaders, body);

    try {
      final response = await _client
          .patch(
            uri,
            headers: allHeaders,
            body: body != null ? json.encode(body) : null,
          )
          .timeout(ApiConfig.connectionTimeout);

      _logResponse(response);
      return response;
    } catch (e) {
      _logError('PATCH', uri, e);
      rethrow;
    }
  }

  /// DELETE request con autenticación automática
  Future<http.Response> delete(
    String endpoint, {
    Map<String, String>? headers,
    bool requiresAuth = true,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final allHeaders = await _buildHeaders(headers, requiresAuth);

    _logRequest('DELETE', uri, allHeaders);

    try {
      final response = await _client
          .delete(uri, headers: allHeaders)
          .timeout(ApiConfig.connectionTimeout);

      _logResponse(response);
      return response;
    } catch (e) {
      _logError('DELETE', uri, e);
      rethrow;
    }
  }

  /// Construye los headers incluyendo el token si es necesario
  Future<Map<String, String>> _buildHeaders(
    Map<String, String>? customHeaders,
    bool requiresAuth,
  ) async {
    final headers = Map<String, String>.from(ApiConfig.defaultHeaders);

    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }

    if (requiresAuth) {
      final token = await _authStorage.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  /// Logging de requests en modo debug
  void _logRequest(
    String method,
    Uri uri,
    Map<String, String> headers, [
    Object? body,
  ]) {
    if (kDebugMode) {
      print('🌐 [$method] $uri');
      print('📤 Headers: $headers');
      if (body != null) {
        print('📦 Body: ${json.encode(body)}');
      }
    }
  }

  /// Logging de responses en modo debug
  void _logResponse(http.Response response) {
    if (kDebugMode) {
      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');
    }
  }

  /// Logging de errores en modo debug
  void _logError(String method, Uri uri, Object error) {
    if (kDebugMode) {
      print('❌ [$method] Error en $uri');
      print('❌ Error: $error');
    }
  }

  /// Cierra el cliente HTTP
  void dispose() {
    _client.close();
  }
}
