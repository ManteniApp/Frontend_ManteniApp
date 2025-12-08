import '../entities/motorcycle_entity.dart';

abstract class MotorcycleRepository {
  /// Registra una nueva motocicleta
  Future<MotorcycleEntity> registerMotorcycle(MotorcycleEntity motorcycle);

  /// Obtiene todas las motocicletas
  Future<List<MotorcycleEntity>> getAllMotorcycles();

  /// Obtiene una motocicleta por ID
  Future<MotorcycleEntity?> getMotorcycleById(String id);

  /// Obtiene una motocicleta por placa
  Future<MotorcycleEntity?> getMotorcycleByPlaca(String placa);

  /// Actualiza una motocicleta existente
  Future<MotorcycleEntity> updateMotorcycle(MotorcycleEntity motorcycle);

  /// Elimina una motocicleta
  Future<bool> deleteMotorcycle(String id);

  /// Busca motocicletas por marca
  Future<List<MotorcycleEntity>> searchMotorcyclesByBrand(String brand);

  /// Busca motocicletas por modelo
  Future<List<MotorcycleEntity>> searchMotorcyclesByModel(String model);
}
