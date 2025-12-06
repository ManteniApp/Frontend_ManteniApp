import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../core/network/api_config.dart';
import '../core/services/auth_storage_service.dart';

/// Página de prueba para diagnosticar problemas con la API
class ApiTestPage extends StatefulWidget {
  const ApiTestPage({super.key});

  @override
  State<ApiTestPage> createState() => _ApiTestPageState();
}

class _ApiTestPageState extends State<ApiTestPage> {
  final List<String> _logs = [];
  final AuthStorageService _authStorage = AuthStorageService();
  bool _isLoading = false;
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final token = await _authStorage.getToken();
    setState(() {
      _token = token;
    });
    _addLog('✅ Token cargado: ${token?.substring(0, 20)}...');
  }

  void _addLog(String message) {
    setState(() {
      _logs.add('${DateTime.now().toIso8601String()}: $message');
    });
    print(message);
  }

  void _clearLogs() {
    setState(() {
      _logs.clear();
    });
  }

  Future<void> _testEndpoint(
    String endpoint, {
    Map<String, String>? queryParams,
  }) async {
    if (_token == null) {
      _addLog('❌ No hay token de autenticación');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      _addLog('🔍 Probando endpoint: $endpoint');

      Uri uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      if (queryParams != null && queryParams.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParams);
      }

      _addLog('📡 URL completa: $uri');
      _addLog('🔑 Headers: ${ApiConfig.getAuthHeaders(_token!)}');

      final response = await http
          .get(uri, headers: ApiConfig.getAuthHeaders(_token!))
          .timeout(const Duration(seconds: 10));

      _addLog('📨 Status Code: ${response.statusCode}');
      _addLog('📦 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final jsonData = json.decode(response.body);
          _addLog('✅ JSON parseado correctamente');
          _addLog('📊 Estructura: ${jsonData.runtimeType}');
          if (jsonData is Map) {
            _addLog('🔑 Keys: ${jsonData.keys.join(', ')}');
          } else if (jsonData is List) {
            _addLog('📋 Lista con ${jsonData.length} elementos');
          }
        } catch (e) {
          _addLog('❌ Error al parsear JSON: $e');
        }
      } else {
        _addLog('❌ Error en la petición');
      }
    } catch (e) {
      _addLog('💥 Exception: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Test & Debug'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _clearLogs,
            tooltip: 'Limpiar logs',
          ),
        ],
      ),
      body: Column(
        children: [
          // Status Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: _token != null ? Colors.green.shade100 : Colors.red.shade100,
            child: Row(
              children: [
                Icon(
                  _token != null ? Icons.check_circle : Icons.error,
                  color: _token != null ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _token != null
                        ? '✅ Autenticado - BaseURL: ${ApiConfig.baseUrl}'
                        : '❌ No autenticado - Inicia sesión primero',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          // Test Buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Tests de Endpoints:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Test Maintenance Summary
                ElevatedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : () {
                          final now = DateTime.now();
                          final startDate = DateTime(
                            2025,
                            11,
                            1,
                          ); // Noviembre 2025
                          _testEndpoint(
                            ApiConfig.maintenanceSummaryEndpoint,
                            queryParams: {
                              'motoId': '10', // ID real de la moto existente
                              'startDate': startDate.toIso8601String().split(
                                'T',
                              )[0],
                              'endDate': now.toIso8601String().split('T')[0],
                              'tipo': 'todos',
                            },
                          );
                        },
                  icon: const Icon(Icons.assessment),
                  label: const Text('Test Maintenance Summary (moto 10)'),
                ),
                const SizedBox(height: 8),

                // Test Recommendations - All
                ElevatedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : () => _testEndpoint('/recommendations'),
                  icon: const Icon(Icons.lightbulb),
                  label: const Text('Test All Recommendations'),
                ),
                const SizedBox(height: 8),

                // Test Recommendations - General
                ElevatedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : () => _testEndpoint('/recommendations/general'),
                  icon: const Icon(Icons.info),
                  label: const Text('Test General Recommendations'),
                ),
                const SizedBox(height: 8),

                // Test Motorcycles
                ElevatedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : () => _testEndpoint(ApiConfig.motorcyclesEndpoint),
                  icon: const Icon(Icons.motorcycle),
                  label: const Text('Test Motorcycles Endpoint'),
                ),
                const SizedBox(height: 8),

                // Test Maintenance History
                ElevatedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : () => _testEndpoint(
                          '${ApiConfig.maintenanceHistoryEndpoint}/10',
                        ), // Con ID real
                  icon: const Icon(Icons.history),
                  label: const Text('Test Maintenance History (moto 10)'),
                ),
              ],
            ),
          ),

          // Loading indicator
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),

          // Logs
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                itemCount: _logs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      _logs[index],
                      style: const TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 12,
                        color: Colors.greenAccent,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
