import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../core/network/api_config.dart';
import '../features/maintenance_recommendations/data/models/recommendation_model.dart';

/// Página de prueba para verificar la conexión con el backend
class TestRecommendationsPage extends StatefulWidget {
  const TestRecommendationsPage({Key? key}) : super(key: key);

  @override
  State<TestRecommendationsPage> createState() =>
      _TestRecommendationsPageState();
}

class _TestRecommendationsPageState extends State<TestRecommendationsPage> {
  String _status = 'Esperando prueba...';
  List<String> _logs = [];
  bool _isLoading = false;
  int _successCount = 0;
  int _errorCount = 0;

  void _addLog(String message) {
    setState(() {
      _logs.add(
        '${DateTime.now().toIso8601String().substring(11, 19)} - $message',
      );
    });
  }

  Future<void> _testAllEndpoints() async {
    setState(() {
      _isLoading = true;
      _logs.clear();
      _successCount = 0;
      _errorCount = 0;
      _status = 'Ejecutando pruebas...';
    });

    _addLog('🚀 Iniciando pruebas de endpoints...');
    _addLog('📡 Backend URL: ${ApiConfig.baseUrl}');

    // Lista de endpoints a probar
    final endpoints = [
      {'name': 'Todas las recomendaciones', 'path': '/recommendations'},
      {
        'name': 'Recomendaciones técnicas',
        'path': '/recommendations/technical',
      },
      {'name': 'Recomendaciones generales', 'path': '/recommendations/general'},
      {
        'name': 'Recomendaciones de seguridad',
        'path': '/recommendations/safety',
      },
      {
        'name': 'Recomendaciones de rendimiento',
        'path': '/recommendations/performance',
      },
      {'name': 'Próximas recomendaciones', 'path': '/recommendations/upcoming'},
    ];

    for (var endpoint in endpoints) {
      await _testEndpoint(endpoint['name']!, endpoint['path']!);
      await Future.delayed(const Duration(milliseconds: 500));
    }

    setState(() {
      _isLoading = false;
      _status =
          'Pruebas completadas: $_successCount exitosas, $_errorCount errores';
    });

    _addLog('');
    _addLog('✅ Pruebas finalizadas');
    _addLog('📊 Resumen: $_successCount exitosos / $_errorCount errores');
  }

  Future<void> _testEndpoint(String name, String path) async {
    _addLog('');
    _addLog('🔍 Probando: $name');
    _addLog('   Endpoint: $path');

    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}$path');
      _addLog('   URL completa: $uri');

      final response = await http
          .get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      _addLog('   Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        _addLog('   ✅ SUCCESS - Recibidos ${jsonData.length} elementos');

        if (jsonData.isNotEmpty) {
          // Intentar parsear el primer elemento
          try {
            final firstItem = MaintenanceRecommendationModel.fromJson(
              jsonData[0] as Map<String, dynamic>,
            );
            _addLog('   📄 Ejemplo: ${firstItem.componentName}');
            _addLog('   📋 Categoría: ${firstItem.category}');
            _addLog('   ⚡ Prioridad: ${firstItem.priority}');
          } catch (e) {
            _addLog('   ⚠️ Error al parsear datos: $e');
          }
        }

        setState(() {
          _successCount++;
        });
      } else if (response.statusCode == 404) {
        _addLog('   ⚠️ WARNING - No hay datos (404)');
        setState(() {
          _successCount++;
        });
      } else {
        _addLog('   ❌ ERROR - Status inesperado: ${response.statusCode}');
        _addLog(
          '   Respuesta: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}',
        );
        setState(() {
          _errorCount++;
        });
      }
    } catch (e) {
      _addLog('   ❌ ERROR - Excepción: $e');
      setState(() {
        _errorCount++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test de Endpoints'),
        backgroundColor: Colors.blue,
        actions: [
          if (!_isLoading)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _testAllEndpoints,
              tooltip: 'Ejecutar pruebas',
            ),
        ],
      ),
      body: Column(
        children: [
          // Status bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: _isLoading
                ? Colors.blue[100]
                : _errorCount > 0
                ? Colors.orange[100]
                : Colors.green[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _status,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 20),
                    const SizedBox(width: 4),
                    Text('Exitosos: $_successCount'),
                    const SizedBox(width: 16),
                    Icon(Icons.error, color: Colors.red, size: 20),
                    const SizedBox(width: 4),
                    Text('Errores: $_errorCount'),
                  ],
                ),
              ],
            ),
          ),

          // Logs
          Expanded(
            child: Container(
              color: Colors.black87,
              child: _logs.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.science, size: 64, color: Colors.white54),
                          const SizedBox(height: 16),
                          Text(
                            'Presiona el botón para iniciar las pruebas',
                            style: TextStyle(color: Colors.white54),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: _logs.length,
                      itemBuilder: (context, index) {
                        final log = _logs[index];
                        Color textColor = Colors.white;

                        if (log.contains('✅') || log.contains('SUCCESS')) {
                          textColor = Colors.greenAccent;
                        } else if (log.contains('❌') || log.contains('ERROR')) {
                          textColor = Colors.redAccent;
                        } else if (log.contains('⚠️') ||
                            log.contains('WARNING')) {
                          textColor = Colors.orangeAccent;
                        } else if (log.contains('🔍') ||
                            log.contains('Probando')) {
                          textColor = Colors.cyanAccent;
                        } else if (log.contains('📡') || log.contains('🚀')) {
                          textColor = Colors.yellowAccent;
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            log,
                            style: TextStyle(
                              color: textColor,
                              fontFamily: 'monospace',
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),

          // Botón de prueba
          if (!_isLoading)
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _testAllEndpoints,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('EJECUTAR PRUEBAS'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
