import '../entities/motorcycle_entity.dart';
import '../repositories/motorcycle_repository.dart';

class RegisterMotorcycleUseCase {
  final MotorcycleRepository repository;

  RegisterMotorcycleUseCase(this.repository);

  Future<MotorcycleEntity> call(MotorcycleEntity motorcycle) async {
    // Validaciones de negocio
    _validateMotorcycleData(motorcycle);

    return await repository.registerMotorcycle(motorcycle);
  }

  void _validateMotorcycleData(MotorcycleEntity motorcycle) {
    if (motorcycle.brand.trim().isEmpty) {
      throw Exception('La marca de la motocicleta es requerida');
    }

    if (motorcycle.model.trim().isEmpty) {
      throw Exception('El modelo de la motocicleta es requerido');
    }

    if (motorcycle.year < 1900 || motorcycle.year > DateTime.now().year + 1) {
      throw Exception('El año de la motocicleta no es válido');
    }

    if (motorcycle.displacement <= 0) {
      throw Exception('El cilindraje debe ser mayor a 0');
    }

    if (motorcycle.mileage < 0) {
      throw Exception('El kilometraje no puede ser negativo');
    }
  }
}
