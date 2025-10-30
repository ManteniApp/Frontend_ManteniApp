import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../domain/entities/maintenance_entity.dart';
import '../../domain/usecases/get_maintenance_history.dart';
import '../../domain/usecases/update_maintenance.dart';
import '../../domain/usecases/delete_maintenance.dart';

class MaintenanceHistoryProvider extends ChangeNotifier {
  final GetMaintenanceHistory getMaintenanceHistoryUseCase;
  final UpdateMaintenance updateMaintenanceUseCase;
  final DeleteMaintenance deleteMaintenanceUseCase;

  MaintenanceHistoryProvider({
    required this.getMaintenanceHistoryUseCase,
    required this.updateMaintenanceUseCase,
    required this.deleteMaintenanceUseCase,
  });

  // Estado
  List<MaintenanceEntity> _maintenances = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Timer para debounce
  Timer? _debounceTimer;

  // Filtros
  DateTime? _selectedDate;
  double? _minPrice;
  double? _maxPrice;
  String? _selectedMotorcycleFilter;

  // Getters
  List<MaintenanceEntity> get maintenances => _maintenances;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DateTime? get selectedDate => _selectedDate;
  double? get minPrice => _minPrice;
  double? get maxPrice => _maxPrice;
  String? get selectedMotorcycleFilter => _selectedMotorcycleFilter;

  /// Cargar historial de mantenimientos con filtros aplicados
  Future<void> loadMaintenanceHistory() async {
    // Evitar llamadas duplicadas mientras se está cargando
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Llamada real al backend
      // ✅ AGREGAR LOGS PARA DEBUG
    print('🔄 Cargando historial de mantenimientos...');
    print('🔍 Filtro de moto actual: $_selectedMotorcycleFilter');
    print('🔍 Fecha seleccionada: $_selectedDate');
    print('🔍 Precio min: $_minPrice, max: $_maxPrice');
      _maintenances = await getMaintenanceHistoryUseCase(
        motorcycleId: _selectedMotorcycleFilter,
      );
    // ✅ LOG DEL RESULTADO
    print('✅ Historial cargado: ${_maintenances.length} mantenimientos');
    for (var maintenance in _maintenances) {
      print('   - ${maintenance.id}: ${maintenance.type} - ${maintenance.motorcycleName} - \$${maintenance.cost}');
    }
      // Aplicar filtros locales (fecha y precio)
      _maintenances = _applyLocalFilters(_maintenances);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Aplicar filtros locales (fecha y precio)
  List<MaintenanceEntity> _applyLocalFilters(List<MaintenanceEntity> data) {
    var filtered = data;

    // Filtro por fecha (día completo)
    if (_selectedDate != null) {
      final selectedDay = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
      );
      filtered = filtered.where((m) {
        final maintenanceDay = DateTime(m.date.year, m.date.month, m.date.day);
        return maintenanceDay == selectedDay;
      }).toList();
    }

    // Filtro por precio
    if (_minPrice != null) {
      filtered = filtered.where((m) => m.cost >= _minPrice!).toList();
    }
    if (_maxPrice != null) {
      filtered = filtered.where((m) => m.cost <= _maxPrice!).toList();
    }

    return filtered;
  }

  /// Método auxiliar para cargar con debounce (evitar múltiples llamadas rápidas)
  void _loadWithDebounce() {
    // Cancelar el timer anterior si existe
    _debounceTimer?.cancel();

    // Crear nuevo timer de 300ms
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      loadMaintenanceHistory();
    });
  }

  /// Establecer filtro de fecha
  void setDateFilter(DateTime? date) {
    _selectedDate = date;
    _loadWithDebounce();
  }

  /// Establecer filtro de precio
  void setPriceFilter({double? minPrice, double? maxPrice}) {
    _minPrice = minPrice;
    _maxPrice = maxPrice;
    _loadWithDebounce();
  }

  /// Establecer filtro de motocicleta
  void setMotorcycleFilter(String? motorcycleId) {
    _selectedMotorcycleFilter = motorcycleId;
    loadMaintenanceHistory(); // Sin debounce para este filtro
  }

  /// Limpiar todos los filtros
  void clearFilters() {
    _selectedDate = null;
    _minPrice = null;
    _maxPrice = null;
    _selectedMotorcycleFilter = null;
    loadMaintenanceHistory();
  }

  /// Limpiar mensajes de error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Eliminar un mantenimiento
  Future<void> deleteMaintenance(String id) async {
    try {
      // Llamada real al backend
      await deleteMaintenanceUseCase(id);

      // Eliminar de la lista local después de confirmar la eliminación
      _maintenances = _maintenances.where((m) => m.id != id).toList();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al eliminar el mantenimiento: ${e.toString()}';
      notifyListeners();
      rethrow;
    }
  }

  /// Editar un mantenimiento
  Future<void> updateMaintenance(MaintenanceEntity updatedMaintenance) async {
    try {
      // Llamada real al backend
      final updated = await updateMaintenanceUseCase(updatedMaintenance);

      // Actualizar en la lista local
      final index = _maintenances.indexWhere((m) => m.id == updated.id);
      if (index != -1) {
        _maintenances[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Error al actualizar el mantenimiento: ${e.toString()}';
      notifyListeners();
      rethrow;
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
