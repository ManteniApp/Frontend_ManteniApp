import 'dart:convert';
import '../models/motorcycle_model.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_config.dart';

abstract class MotorcycleRemoteDataSource {
  Future<MotorcycleModel> registerMotorcycle(MotorcycleModel motorcycle);
  Future<List<MotorcycleModel>> getAllMotorcycles();
  Future<MotorcycleModel?> getMotorcycleById(String id);
  Future<MotorcycleModel?> getMotorcycleByPlaca(String placa);
  Future<MotorcycleModel> updateMotorcycle(MotorcycleModel motorcycle);
  Future<bool> deleteMotorcycle(String id);
  Future<List<MotorcycleModel>> searchMotorcyclesByBrand(String brand);
  Future<List<MotorcycleModel>> searchMotorcyclesByModel(String model);
}

class MotorcycleRemoteDataSourceImpl implements MotorcycleRemoteDataSource {
  final ApiClient apiClient;

  MotorcycleRemoteDataSourceImpl({ApiClient? apiClient})
    : apiClient = apiClient ?? ApiClient();

  @override
  Future<MotorcycleModel> registerMotorcycle(MotorcycleModel motorcycle) async {
    try {
      final response = await apiClient.post(
        ApiConfig.motorcyclesEndpoint,
        body: motorcycle.toJson(),
        requiresAuth: true,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return MotorcycleModel.fromJson(jsonData);
      } else {
        throw Exception(
          'Error al registrar motocicleta: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  @override
  Future<List<MotorcycleModel>> getAllMotorcycles() async {
    try {
      final response = await apiClient.get(
        ApiConfig.motorcyclesEndpoint,
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => MotorcycleModel.fromJson(json)).toList();
      } else {
        throw Exception(
          'Error al obtener motocicletas: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  @override
  Future<MotorcycleModel?> getMotorcycleById(String id) async {
    try {
      final response = await apiClient.get(
        '${ApiConfig.motorcyclesEndpoint}/$id',
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return MotorcycleModel.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Error al obtener motocicleta: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  @override
  Future<MotorcycleModel?> getMotorcycleByPlaca(String placa) async {
    try {
      final response = await apiClient.get(
        '${ApiConfig.motorcyclesEndpoint}/placa/$placa',
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return MotorcycleModel.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception(
          'Error al obtener motocicleta por placa: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  @override
  Future<MotorcycleModel> updateMotorcycle(MotorcycleModel motorcycle) async {
    try {
      final response = await apiClient.patch(
        '${ApiConfig.motorcyclesEndpoint}/${motorcycle.id}',
        body: motorcycle.toJson(),
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return MotorcycleModel.fromJson(jsonData);
      } else {
        throw Exception(
          'Error al actualizar motocicleta: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  @override
  Future<bool> deleteMotorcycle(String id) async {
    try {
      final response = await apiClient.delete(
        '${ApiConfig.motorcyclesEndpoint}/$id',
        requiresAuth: true,
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  @override
  Future<List<MotorcycleModel>> searchMotorcyclesByBrand(String brand) async {
    try {
      final response = await apiClient.get(
        '${ApiConfig.motorcyclesEndpoint}/search?brand=$brand',
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => MotorcycleModel.fromJson(json)).toList();
      } else {
        throw Exception('Error al buscar motocicletas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  @override
  Future<List<MotorcycleModel>> searchMotorcyclesByModel(String model) async {
    try {
      final response = await apiClient.get(
        '${ApiConfig.motorcyclesEndpoint}/search?model=$model',
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => MotorcycleModel.fromJson(json)).toList();
      } else {
        throw Exception('Error al buscar motocicletas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
