import 'package:flutter/foundation.dart';
import '../../domain/entities/maintenance_report_entity.dart';
import '../../domain/usecases/get_maintenance_report.dart';
import '../../domain/usecases/export_report_to_pdf.dart';

/// Estados del reporte
enum ReportStatus { initial, loading, loaded, error, exporting, exported }

/// Provider para manejar el estado del reporte de mantenimientos
class MaintenanceReportProvider extends ChangeNotifier {
  final GetMaintenanceReport getMaintenanceReportUseCase;
  final ExportReportToPdf exportReportToPdfUseCase;

  MaintenanceReportProvider({
    required this.getMaintenanceReportUseCase,
    required this.exportReportToPdfUseCase,
  });

  // Estado
  ReportStatus _status = ReportStatus.initial;
  MaintenanceReportEntity? _report;
  String? _errorMessage;
  String? _pdfUrl;

  // Filtros
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedMotorcycleId;

  // Getters
  ReportStatus get status => _status;
  MaintenanceReportEntity? get report => _report;
  String? get errorMessage => _errorMessage;
  String? get pdfUrl => _pdfUrl;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  String? get selectedMotorcycleId => _selectedMotorcycleId;

  bool get hasData => _report != null && _report!.totalMaintenances > 0;
  bool get isLoading => _status == ReportStatus.loading;
  bool get isExporting => _status == ReportStatus.exporting;

  /// Carga el reporte con los filtros actuales
  Future<void> loadReport() async {
    print('🔄 [ReportProvider] Iniciando carga de reporte...');
    print('🔄 [ReportProvider] Estado actual: $_status');

    // Validar que tenemos los datos requeridos por la API
    if (_selectedMotorcycleId == null || _selectedMotorcycleId!.isEmpty) {
      print(
        '⚠️ [ReportProvider] No hay motocicleta seleccionada, no se puede cargar el reporte',
      );
      _status = ReportStatus.error;
      _errorMessage = 'Por favor selecciona una motocicleta';
      notifyListeners();
      return;
    }

    // Establecer fechas por defecto si no están definidas
    final now = DateTime.now();
    final effectiveStartDate =
        _startDate ?? DateTime(now.year, 1, 1); // Inicio del año actual
    final effectiveEndDate = _endDate ?? now; // Fecha actual

    print('🔄 [ReportProvider] Parámetros:');
    print('  - Motocicleta: $_selectedMotorcycleId');
    print('  - Fecha inicio: $effectiveStartDate');
    print('  - Fecha fin: $effectiveEndDate');

    _status = ReportStatus.loading;
    _errorMessage = null;
    notifyListeners();
    print(
      '🔄 [ReportProvider] Estado cambiado a loading, notificando listeners...',
    );

    try {
      print('🔄 [ReportProvider] Llamando al use case...');
      _report = await getMaintenanceReportUseCase(
        startDate: effectiveStartDate,
        endDate: effectiveEndDate,
        motorcycleId: _selectedMotorcycleId,
      );
      print('✅ [ReportProvider] Reporte obtenido exitosamente');
      print(
        '✅ [ReportProvider] Total mantenimientos: ${_report?.totalMaintenances}',
      );
      _status = ReportStatus.loaded;
      notifyListeners();
      print(
        '✅ [ReportProvider] Estado cambiado a loaded, notificando listeners...',
      );
    } catch (e) {
      print('❌ [ReportProvider] Error al cargar reporte: $e');
      _errorMessage = e.toString();
      _status = ReportStatus.error;
      notifyListeners();
      print(
        '❌ [ReportProvider] Estado cambiado a error, notificando listeners...',
      );
    }
  }

  /// Establece el rango de fechas y recarga el reporte
  Future<void> setDateRange(DateTime? startDate, DateTime? endDate) async {
    _startDate = startDate;
    _endDate = endDate;
    notifyListeners();
    await loadReport();
  }

  /// Establece la motocicleta seleccionada y recarga el reporte
  Future<void> setMotorcycle(String? motorcycleId) async {
    _selectedMotorcycleId = motorcycleId;
    notifyListeners();
    await loadReport();
  }

  /// Limpia todos los filtros y recarga el reporte
  Future<void> clearFilters() async {
    _startDate = null;
    _endDate = null;
    _selectedMotorcycleId = null;
    notifyListeners();
    await loadReport();
  }

  /// Exporta el reporte a PDF
  Future<void> exportToPdf() async {
    if (!hasData) {
      _errorMessage = 'No hay datos para exportar';
      _status = ReportStatus.error;
      notifyListeners();
      return;
    }

    // Validar que tenemos los datos requeridos por la API
    if (_selectedMotorcycleId == null || _selectedMotorcycleId!.isEmpty) {
      _errorMessage = 'Por favor selecciona una motocicleta';
      _status = ReportStatus.error;
      notifyListeners();
      return;
    }

    // Establecer fechas por defecto si no están definidas
    final now = DateTime.now();
    final effectiveStartDate = _startDate ?? DateTime(now.year, 1, 1);
    final effectiveEndDate = _endDate ?? now;

    _status = ReportStatus.exporting;
    _pdfUrl = null;
    _errorMessage = null;
    notifyListeners();

    try {
      _pdfUrl = await exportReportToPdfUseCase(
        startDate: effectiveStartDate,
        endDate: effectiveEndDate,
        motorcycleId: _selectedMotorcycleId,
      );
      _status = ReportStatus.exported;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _status = ReportStatus.error;
      notifyListeners();
    }
  }

  /// Reinicia el estado
  void reset() {
    _status = ReportStatus.initial;
    _report = null;
    _errorMessage = null;
    _pdfUrl = null;
    _startDate = null;
    _endDate = null;
    _selectedMotorcycleId = null;
    notifyListeners();
  }
}
