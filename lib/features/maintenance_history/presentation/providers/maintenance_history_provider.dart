import 'package:flutter/foundation.dart';
import '../../domain/entities/maintenance_entity.dart';
import '../../domain/usecases/get_maintenance_history.dart';

class MaintenanceHistoryProvider extends ChangeNotifier {
  final GetMaintenanceHistory getMaintenanceHistoryUseCase;

  MaintenanceHistoryProvider({required this.getMaintenanceHistoryUseCase});

  // Estado
  List<MaintenanceEntity> _maintenances = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Filtros
  DateTime? _startDate;
  DateTime? _endDate;
  double? _minPrice;
  double? _maxPrice;
  String? _selectedMotorcycleFilter;

  // Getters
  List<MaintenanceEntity> get maintenances => _maintenances;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  double? get minPrice => _minPrice;
  double? get maxPrice => _maxPrice;
  String? get selectedMotorcycleFilter => _selectedMotorcycleFilter;

  /// Cargar historial de mantenimientos con filtros aplicados
  Future<void> loadMaintenanceHistory() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: Descomentar cuando el backend esté listo
      // _maintenances = await getMaintenanceHistoryUseCase(
      //   startDate: _startDate,
      //   endDate: _endDate,
      //   minPrice: _minPrice,
      //   maxPrice: _maxPrice,
      //   motorcycleId: _selectedMotorcycleFilter,
      // );

      // MOCK DATA - Datos de prueba
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simular delay de red
      _maintenances = _getMockData();

      // Aplicar filtros manualmente (solo para mock)
      _maintenances = _applyMockFilters(_maintenances);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Generar datos mock para pruebas
  List<MaintenanceEntity> _getMockData() {
    final now = DateTime.now();
    return [
      // Hoy
      MaintenanceEntity(
        id: '1',
        type: 'General',
        date: now,
        cost: 150.00,
        motorcycleName: 'Honda CB190R',
        description: 'Cambio de aceite y filtros',
        notes: 'Servicio completo realizado. Todo en buen estado.',
      ),
      MaintenanceEntity(
        id: '2',
        type: 'Eléctrico',
        date: now.subtract(const Duration(hours: 3)),
        cost: 320.50,
        motorcycleName: 'Yamaha MT-07',
        description: 'Revisión del sistema eléctrico',
        notes: 'Se reemplazó la batería. Sistema funcionando correctamente.',
      ),

      // Ayer
      MaintenanceEntity(
        id: '3',
        type: 'Mecánico',
        date: now.subtract(const Duration(days: 1)),
        cost: 450.00,
        motorcycleName: 'Suzuki GSX-R600',
        description: 'Ajuste de cadena y piñones',
        notes: 'Cadena en buen estado, solo requirió ajuste y lubricación.',
      ),
      MaintenanceEntity(
        id: '4',
        type: 'General',
        date: now.subtract(const Duration(days: 1, hours: 5)),
        cost: 85.00,
        motorcycleName: 'Honda CB190R',
        description: 'Limpieza general y lubricación',
        notes: 'Mantenimiento preventivo.',
      ),

      // Anteriores
      MaintenanceEntity(
        id: '5',
        type: 'Mecánico',
        date: now.subtract(const Duration(days: 3)),
        cost: 680.00,
        motorcycleName: 'Kawasaki Ninja 400',
        description: 'Cambio de pastillas de freno',
        notes:
            'Se reemplazaron pastillas delanteras y traseras. Discos en buen estado.',
      ),
      MaintenanceEntity(
        id: '6',
        type: 'Eléctrico',
        date: now.subtract(const Duration(days: 7)),
        cost: 250.00,
        motorcycleName: 'BMW S1000RR',
        description: 'Reemplazo de luces LED',
        notes: 'Se instalaron luces LED de alta calidad.',
      ),
      MaintenanceEntity(
        id: '7',
        type: 'General',
        date: now.subtract(const Duration(days: 10)),
        cost: 120.00,
        motorcycleName: 'Yamaha MT-07',
        description: 'Cambio de aceite',
        notes: 'Servicio de 5,000 km.',
      ),
      MaintenanceEntity(
        id: '8',
        type: 'Mecánico',
        date: now.subtract(const Duration(days: 15)),
        cost: 890.00,
        motorcycleName: 'Suzuki GSX-R600',
        description: 'Revisión de suspensión',
        notes:
            'Se ajustó la suspensión delantera y trasera según peso del piloto.',
      ),
      MaintenanceEntity(
        id: '9',
        type: 'General',
        date: now.subtract(const Duration(days: 20)),
        cost: 95.00,
        motorcycleName: 'Honda CB190R',
        description: 'Limpieza de carburador',
        notes: 'Carburador limpio y calibrado.',
      ),
      MaintenanceEntity(
        id: '10',
        type: 'Eléctrico',
        date: now.subtract(const Duration(days: 25)),
        cost: 420.00,
        motorcycleName: 'Kawasaki Ninja 400',
        description: 'Instalación de alarma',
        notes: 'Sistema de alarma instalado y probado correctamente.',
      ),
    ];
  }

  /// Aplicar filtros a los datos mock
  List<MaintenanceEntity> _applyMockFilters(List<MaintenanceEntity> data) {
    var filtered = data;

    // Filtro por fecha
    if (_startDate != null) {
      filtered = filtered
          .where(
            (m) =>
                m.date.isAfter(_startDate!) ||
                m.date.isAtSameMomentAs(_startDate!),
          )
          .toList();
    }
    if (_endDate != null) {
      final endOfDay = DateTime(
        _endDate!.year,
        _endDate!.month,
        _endDate!.day,
        23,
        59,
        59,
      );
      filtered = filtered
          .where(
            (m) =>
                m.date.isBefore(endOfDay) || m.date.isAtSameMomentAs(endOfDay),
          )
          .toList();
    }

    // Filtro por precio
    if (_minPrice != null) {
      filtered = filtered.where((m) => m.cost >= _minPrice!).toList();
    }
    if (_maxPrice != null) {
      filtered = filtered.where((m) => m.cost <= _maxPrice!).toList();
    }

    // Filtro por motocicleta
    if (_selectedMotorcycleFilter != null) {
      // Convertir ID a nombre de moto (para el mock)
      final motorcycleNames = {
        '1': 'Honda CB190R',
        '2': 'Yamaha MT-07',
        '3': 'Suzuki GSX-R600',
        '4': 'Kawasaki Ninja 400',
        '5': 'BMW S1000RR',
      };
      final motorcycleName = motorcycleNames[_selectedMotorcycleFilter];
      if (motorcycleName != null) {
        filtered = filtered
            .where((m) => m.motorcycleName == motorcycleName)
            .toList();
      }
    }

    return filtered;
  }

  /// Establecer filtro de fecha
  void setDateFilter({DateTime? startDate, DateTime? endDate}) {
    _startDate = startDate;
    _endDate = endDate;
    loadMaintenanceHistory();
  }

  /// Establecer filtro de precio
  void setPriceFilter({double? minPrice, double? maxPrice}) {
    _minPrice = minPrice;
    _maxPrice = maxPrice;
    loadMaintenanceHistory();
  }

  /// Establecer filtro de motocicleta
  void setMotorcycleFilter(String? motorcycleId) {
    _selectedMotorcycleFilter = motorcycleId;
    loadMaintenanceHistory();
  }

  /// Limpiar todos los filtros
  void clearFilters() {
    _startDate = null;
    _endDate = null;
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
}
