import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recommendation_provider.dart';

/// Página de prueba para verificar la conexión con el backend
class TestRecommendationsPage extends StatefulWidget {
  const TestRecommendationsPage({Key? key}) : super(key: key);

  @override
  State<TestRecommendationsPage> createState() =>
      _TestRecommendationsPageState();
}

class _TestRecommendationsPageState extends State<TestRecommendationsPage> {
  String _testResult = 'Presiona un botón para probar';
  bool _isLoading = false;

  Future<void> _testEndpoint(
    String testName,
    Future<void> Function() test,
  ) async {
    setState(() {
      _isLoading = true;
      _testResult = 'Probando $testName...';
    });

    try {
      await test();
      final provider = context.read<MaintenanceRecommendationProvider>();

      setState(() {
        _isLoading = false;
        if (provider.state == RecommendationState.loaded) {
          _testResult =
              '✅ $testName: ${provider.recommendations.length} recomendaciones recibidas\n\n'
              'Primeras 3:\n${_getFirstThree(provider.recommendations)}';
        } else if (provider.state == RecommendationState.error) {
          _testResult = '❌ Error en $testName:\n${provider.errorMessage}';
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _testResult = '❌ Excepción en $testName:\n$e';
      });
    }
  }

  String _getFirstThree(List recommendations) {
    if (recommendations.isEmpty) return 'Lista vacía';
    return recommendations
        .take(3)
        .map(
          (r) =>
              '• ${r.componentName} (${r.category}) - Prioridad: ${r.priority}',
        )
        .join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Backend - Recomendaciones'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '🧪 Prueba de Endpoints',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Backend debe estar en http://localhost:3000',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Resultado
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Text(
                      _testResult,
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
            ),

            const SizedBox(height: 24),
            const Text(
              'Pruebas Disponibles:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Botones de prueba
            _buildTestButton(
              'GET /recommendations',
              'Todas las recomendaciones',
              Colors.blue,
              () => _testEndpoint(
                'GET /recommendations',
                () => context
                    .read<MaintenanceRecommendationProvider>()
                    .loadAllRecommendations(),
              ),
            ),

            _buildTestButton(
              'GET /recommendations/general',
              'Recomendaciones generales',
              Colors.green,
              () => _testEndpoint(
                'GET /recommendations/general',
                () => context
                    .read<MaintenanceRecommendationProvider>()
                    .loadGeneralRecommendations(),
              ),
            ),

            _buildTestButton(
              'GET /recommendations/technical',
              'Recomendaciones técnicas',
              Colors.orange,
              () => _testEndpoint(
                'GET /recommendations/technical',
                () => context
                    .read<MaintenanceRecommendationProvider>()
                    .loadTechnicalRecommendations(),
              ),
            ),

            _buildTestButton(
              'GET /recommendations/safety',
              'Recomendaciones de seguridad',
              Colors.red,
              () => _testEndpoint(
                'GET /recommendations/safety',
                () => context
                    .read<MaintenanceRecommendationProvider>()
                    .loadSafetyRecommendations(),
              ),
            ),

            _buildTestButton(
              'GET /recommendations/performance',
              'Recomendaciones de rendimiento',
              Colors.teal,
              () => _testEndpoint(
                'GET /recommendations/performance',
                () => context
                    .read<MaintenanceRecommendationProvider>()
                    .loadPerformanceRecommendations(),
              ),
            ),

            _buildTestButton(
              'GET /recommendations/upcoming',
              'Próximas recomendaciones',
              Colors.purple,
              () => _testEndpoint(
                'GET /recommendations/upcoming',
                () => context
                    .read<MaintenanceRecommendationProvider>()
                    .loadUpcomingRecommendations(),
              ),
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // Pruebas con parámetros
            _buildTestButton(
              'GET /recommendations/priority/alta',
              'Por prioridad ALTA',
              Colors.deepOrange,
              () => _testEndpoint(
                'GET /recommendations/priority/alta',
                () => context
                    .read<MaintenanceRecommendationProvider>()
                    .loadRecommendationsByPriority('alta'),
              ),
            ),

            _buildTestButton(
              'GET /recommendations/category/Aceite',
              'Por categoría ACEITE',
              Colors.amber,
              () => _testEndpoint(
                'GET /recommendations/category/Aceite',
                () => context
                    .read<MaintenanceRecommendationProvider>()
                    .loadRecommendationsByCategory('Aceite'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestButton(
    String endpoint,
    String description,
    Color color,
    VoidCallback onPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton(
        onPressed: _isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              endpoint,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 4),
            Text(description, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
