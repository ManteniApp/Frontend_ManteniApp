import '../entities/motorcycle_entity.dart';
import '../repositories/motorcycle_repository.dart';

/// Caso de uso para obtener todas las motocicletas del usuario
class GetAllMotorcycles {
  final MotorcycleRepository repository;

  GetAllMotorcycles(this.repository);

  /// Ejecuta el caso de uso
  Future<List<MotorcycleEntity>> call() async {
    return await repository.getAllMotorcycles();
  }
}
