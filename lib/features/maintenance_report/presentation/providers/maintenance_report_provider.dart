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
    _status = ReportStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _report = await getMaintenanceReportUseCase(
        startDate: _startDate,
        endDate: _endDate,
        motorcycleId: _selectedMotorcycleId,
      );
      _status = ReportStatus.loaded;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _status = ReportStatus.error;
      notifyListeners();
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

    _status = ReportStatus.exporting;
    _pdfUrl = null;
    _errorMessage = null;
    notifyListeners();

    try {
      _pdfUrl = await exportReportToPdfUseCase(
        startDate: _startDate,
        endDate: _endDate,
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
