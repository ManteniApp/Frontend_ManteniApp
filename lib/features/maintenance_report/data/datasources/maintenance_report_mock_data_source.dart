import '../models/maintenance_report_model.dart';

/// Data source MOCK para el reporte de mantenimientos
/// ⚠️ Este data source devuelve datos simulados para desarrollo
/// Cambiar a MaintenanceReportRemoteDataSourceImpl cuando el backend esté listo
class MaintenanceReportMockDataSource {
  /// Simula un delay de red
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  /// Obtiene un reporte MOCK de mantenimientos
  Future<MaintenanceReportModel> getMaintenanceReport({
    DateTime? startDate,
    DateTime? endDate,
    String? motorcycleId,
  }) async {
    print('🎭 [MOCK] Obteniendo reporte simulado...');
    await _simulateNetworkDelay();

    // Datos de ejemplo que coinciden con la estructura esperada
    final mockData = {
      "totalMaintenances": 12,
      "totalCost": 4850.50,
      "averageCost": 404.21,
      "mostFrequentServices": [
        {"serviceName": "Cambio de aceite", "count": 5},
        {"serviceName": "Revisión de frenos", "count": 3},
        {"serviceName": "Cambio de llantas", "count": 2},
        {"serviceName": "Ajuste de cadena", "count": 2},
      ],
      "lastMaintenanceDate": DateTime.now()
          .subtract(const Duration(days: 15))
          .toIso8601String(),
      "startDate": startDate?.toIso8601String(),
      "endDate": endDate?.toIso8601String(),
    };

    print(
      '✅ [MOCK] Reporte generado con ${mockData['totalMaintenances']} mantenimientos',
    );
    return MaintenanceReportModel.fromJson(mockData);
  }

  /// Simula la exportación a PDF
  Future<String> exportReportToPdf({
    DateTime? startDate,
    DateTime? endDate,
    String? motorcycleId,
  }) async {
    print('🎭 [MOCK] Generando PDF simulado...');
    await _simulateNetworkDelay();

    // Retornar una URL simulada de PDF
    final mockPdfUrl =
        'https://example.com/reports/maintenance_report_${DateTime.now().millisecondsSinceEpoch}.pdf';

    print('✅ [MOCK] PDF generado: $mockPdfUrl');
    return mockPdfUrl;
  }
}
