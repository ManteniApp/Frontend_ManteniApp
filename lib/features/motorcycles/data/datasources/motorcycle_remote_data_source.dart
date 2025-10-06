import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/motorcycle_model.dart';

abstract class MotorcycleRemoteDataSource {
  Future<MotorcycleModel> registerMotorcycle(MotorcycleModel motorcycle);
  Future<List<MotorcycleModel>> getAllMotorcycles();
  Future<MotorcycleModel?> getMotorcycleById(String id);
  Future<MotorcycleModel> updateMotorcycle(MotorcycleModel motorcycle);
  Future<bool> deleteMotorcycle(String id);
  Future<List<MotorcycleModel>> searchMotorcyclesByBrand(String brand);
  Future<List<MotorcycleModel>> searchMotorcyclesByModel(String model);
}

class MotorcycleRemoteDataSourceImpl implements MotorcycleRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  MotorcycleRemoteDataSourceImpl({required this.client, required this.baseUrl});

  @override
  Future<MotorcycleModel> registerMotorcycle(MotorcycleModel motorcycle) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/motorcycles'),
        headers: {
          'Content-Type': 'application/json',
          // Aquí puedes agregar headers de autenticación si es necesario
          // 'Authorization': 'Bearer $token',
        },
        body: json.encode(motorcycle.toJson()),
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
      final response = await client.get(
        Uri.parse('$baseUrl/motorcycles'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer $token',
        },
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
      final response = await client.get(
        Uri.parse('$baseUrl/motorcycles/$id'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer $token',
        },
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
  Future<MotorcycleModel> updateMotorcycle(MotorcycleModel motorcycle) async {
    try {
      final response = await client.put(
        Uri.parse('$baseUrl/motorcycles/${motorcycle.id}'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer $token',
        },
        body: json.encode(motorcycle.toJson()),
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
      final response = await client.delete(
        Uri.parse('$baseUrl/motorcycles/$id'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  @override
  Future<List<MotorcycleModel>> searchMotorcyclesByBrand(String brand) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/motorcycles/search?brand=$brand'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer $token',
        },
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
      final response = await client.get(
        Uri.parse('$baseUrl/motorcycles/search?model=$model'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer $token',
        },
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
