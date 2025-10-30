import 'package:flutter/foundation.dart';
import '../../domain/entities/motorcycle_entity.dart';
import '../../domain/usecases/register_motorcycle.dart';

class MotorcycleProvider extends ChangeNotifier {
  final RegisterMotorcycleUseCase registerMotorcycleUseCase;

  MotorcycleProvider({required this.registerMotorcycleUseCase});

  // Estado de carga
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Mensajes de error
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Mensaje de éxito
  String? _successMessage;
  String? get successMessage => _successMessage;

  // Registrar una nueva motocicleta
  Future<bool> registerMotorcycle(MotorcycleEntity motorcycle) async {
    _setLoading(true);
    _clearMessages();

    try {
      await registerMotorcycleUseCase(motorcycle);

      _successMessage = 'Motocicleta registrada exitosamente';
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }


  // Sobrecarga del método para aceptar parámetros individuales
  Future<bool> registerMotorcycleWithParams({
    required String marca,
    required String modelo,
    required String placa, // 👈 Agregado
    required int ano,
    required String cilindraje,
    required int kilometraje,
  }) async {
    final motorcycle = MotorcycleEntity(
      brand: marca,
      model: modelo,
      licensePlate: placa, // 👈 Agregado
      year: ano,
      displacement: int.tryParse(cilindraje.replaceAll('cc', '')) ?? 0,
      mileage: kilometraje,
    );

    return await registerMotorcycle(motorcycle);
  }

  // Versión temporal en el provider
  Future<bool> updateMotorcycleWithParams({
    required String id,
    required String marca,
    required String modelo,
    required String placa,
    required int ano,
    required String cilindraje,
    required int kilometraje,
  }) async {
    // Por ahora, usa el mismo método que registro
    return await registerMotorcycleWithParams(
      marca: marca,
      modelo: modelo,
      placa: placa,
      ano: ano,
      cilindraje: cilindraje,
      kilometraje: kilometraje,
    );
  }

  // Limpiar mensajes
  void clearMessages() {
    _clearMessages();
    notifyListeners();
  }

  // Métodos privados
  void _setLoading(bool loading) {
    _isLoading = loading;
  }

  void _clearMessages() {
    _errorMessage = null;
    _successMessage = null;
  }
}
