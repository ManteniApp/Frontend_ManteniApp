import '../../domain/entities/motorcycle_entity.dart';
import '../../domain/repositories/motorcycle_repository.dart';
import '../datasources/motorcycle_remote_data_source.dart';
import '../models/motorcycle_model.dart';

class MotorcycleRepositoryImpl implements MotorcycleRepository {
  final MotorcycleRemoteDataSource remoteDataSource;

  MotorcycleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<MotorcycleEntity> registerMotorcycle(
    MotorcycleEntity motorcycle,
  ) async {
    try {
      final motorcycleModel = MotorcycleModel.fromEntity(motorcycle);
      final result = await remoteDataSource.registerMotorcycle(motorcycleModel);
      return result.toEntity();
    } catch (e) {
      throw Exception('Error al registrar motocicleta: $e');
    }
  }

  @override
  Future<List<MotorcycleEntity>> getAllMotorcycles() async {
    try {
      final motorcycleModels = await remoteDataSource.getAllMotorcycles();
      return motorcycleModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Error al obtener motocicletas: $e');
    }
  }

  @override
  Future<MotorcycleEntity?> getMotorcycleById(String id) async {
    try {
      final motorcycleModel = await remoteDataSource.getMotorcycleById(id);
      return motorcycleModel?.toEntity();
    } catch (e) {
      throw Exception('Error al obtener motocicleta: $e');
    }
  }

  @override
  Future<MotorcycleEntity?> getMotorcycleByPlaca(String placa) async {
    try {
      final motorcycleModel = await remoteDataSource.getMotorcycleByPlaca(
        placa,
      );
      return motorcycleModel?.toEntity();
    } catch (e) {
      throw Exception('Error al obtener motocicleta por placa: $e');
    }
  }

  @override
  Future<MotorcycleEntity> updateMotorcycle(MotorcycleEntity motorcycle) async {
    try {
      final motorcycleModel = MotorcycleModel.fromEntity(motorcycle);
      final result = await remoteDataSource.updateMotorcycle(motorcycleModel);
      return result.toEntity();
    } catch (e) {
      throw Exception('Error al actualizar motocicleta: $e');
    }
  }

  @override
  Future<bool> deleteMotorcycle(String id) async {
    try {
      return await remoteDataSource.deleteMotorcycle(id);
    } catch (e) {
      throw Exception('Error al eliminar motocicleta: $e');
    }
  }

  @override
  Future<List<MotorcycleEntity>> searchMotorcyclesByBrand(String brand) async {
    try {
      final motorcycleModels = await remoteDataSource.searchMotorcyclesByBrand(
        brand,
      );
      return motorcycleModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Error al buscar motocicletas: $e');
    }
  }

  @override
  Future<List<MotorcycleEntity>> searchMotorcyclesByModel(String model) async {
    try {
      final motorcycleModels = await remoteDataSource.searchMotorcyclesByModel(
        model,
      );
      return motorcycleModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Error al buscar motocicletas: $e');
    }
  }
}
