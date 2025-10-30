
import 'package:flutter/foundation.dart';
import 'package:frontend_manteniapp/features/register_maintenance/domain/entities/maintenance_entity.dart';
import 'package:frontend_manteniapp/features/register_maintenance/domain/usecases/create_maintenance.dart';

class MaintenanceProvider with ChangeNotifier {
  
  final CreateMaintenanceUseCase createMaintenanceUseCase;
  bool _isCreating = false;

  MaintenanceProvider({required this.createMaintenanceUseCase});

  // Estados
  bool _isLoading = false;
  String? _error;
  Maintenance? _lastCreatedMaintenance;

  bool get isLoading => _isLoading;
  String? get error => _error;
  Maintenance? get lastCreatedMaintenance => _lastCreatedMaintenance;

  // Datos del formulario
  String? _selectedMotoId;
  DateTime? _selectedDate;
  String? _selectedTipo;
  String? _descripcion;
  int? _kilometraje;
  double? _costo;

  String? get selectedMotoId => _selectedMotoId;
  DateTime? get selectedDate => _selectedDate;
  String? get selectedTipo => _selectedTipo;
  String? get descripcion => _descripcion;
  int? get kilometraje => _kilometraje;
  double? get costo => _costo;

  // Lista de tipos de mantenimiento
  final List<String> tiposMantenimiento = [
    'Cambio de aceite',
    'Afinamiento',
    'Frenos',
    'Llantas',
    'Cadena',
    'Batería',
    'Suspensión',
    'Electrico',
    'Otro'
  ];

  void setSelectedMoto(String? motoId) {
    _selectedMotoId = motoId;
    notifyListeners();
  }

  void setSelectedDate(DateTime? date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setSelectedTipo(String? tipo) {
    _selectedTipo = tipo;
    notifyListeners();
  }

  void setDescripcion(String? desc) {
    _descripcion = desc;
    notifyListeners();
  }

  void setKilometraje(int? km) {
    _kilometraje = km;
    notifyListeners();
  }

  void setCosto(dynamic value) {
    
    if (value == null) {
      _costo = null;
    } else if (value is double) {
      _costo = value;
    } else if (value is int) {
      _costo = value.toDouble();
    } else if (value is String) {
      _costo = double.tryParse(value.replaceAll(',', '.'));
    } else {
      _costo = null;
    }
  }

  bool get isFormValid {
    final bool motoValida = _selectedMotoId != null && _selectedMotoId!.isNotEmpty;
    final bool tipoValido = _selectedTipo != null && _selectedTipo!.isNotEmpty;
    final bool fechaValida = _selectedDate != null;
    
    return motoValida && tipoValido && fechaValida;
  }

  Future<bool> createMaintenance() async {
    if (_isCreating) {
      print('⚠️ Creación ya en progreso, ignorando llamada duplicada');
      return false;
    }

    if (!isFormValid) return false;

    _isLoading = true;
    _isCreating = true; // ← MARCAR COMO EN PROCESO
    _error = null;
    notifyListeners();

    try {
      // Convierte el String ID a int para la entidad
      final motoIdInt = int.tryParse(_selectedMotoId!);
      if (motoIdInt == null) {
        throw Exception('ID de motocicleta no válido: $_selectedMotoId');
      }

      // Validar que el costo sea un número válido
      if (_costo != null && _costo! <= 0) {
        throw Exception('El costo debe ser mayor a 0');
      }

      final maintenance = Maintenance(
        motoId: motoIdInt,
        fecha: _selectedDate!,
        tipo: _selectedTipo!,
        descripcion: _descripcion,
        kilometraje: _kilometraje,
        costo: _costo,
      );

      _lastCreatedMaintenance = await createMaintenanceUseCase.execute(maintenance);
            
      _isLoading = false;
      _isCreating = false; // ← DESMARCAR
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _isCreating = false; // ← DESMARCAR INCLUSO EN ERROR
      _error = 'Error al crear el mantenimiento: $e';
      notifyListeners();
      return false;
    }
  }

  void clearForm() {
    _selectedMotoId = null;
    _selectedDate = null;
    _selectedTipo = null;
    _descripcion = null;
    _kilometraje = null;
    _costo = null;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}