import 'dart:convert';
import 'package:frontend_manteniapp/core/network/api_config.dart';
import 'package:frontend_manteniapp/core/services/auth_storage_service.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class PerfilRemoteDataSource {
  final String baseUrl = '${ApiConfig.baseUrl}/users';

  /// ✅ Validar que el ID sea válido antes de llamar al backend
  int _validateUserId(String userId) {
    if (userId.isEmpty || userId == 'null' || userId == 'user') {
      throw Exception('UserId vacío o inválido: "$userId"');
    }

    final numericId = int.tryParse(userId);
    if (numericId == null) {
      throw Exception('ID de usuario inválido: $userId');
    }

    return numericId;
  }

  /// ✅ Obtener perfil del usuario
  Future<UserModel> getUserProfile(String userId) async {
    final numericId = _validateUserId(userId);
    final url = Uri.parse('$baseUrl/profile/$numericId');

    print('📤 GET: $url');

    final response = await http.get(url, headers: ApiConfig.defaultHeaders);

    print('📥 Status: ${response.statusCode}');
    print('📥 Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is Map<String, dynamic>) {
        if (data['id'] != null) return UserModel.fromJson(data);
        if (data['user'] != null) return UserModel.fromJson(data['user']);
        if (data['data'] != null) return UserModel.fromJson(data['data']);
      }
      throw Exception('Estructura inesperada en respuesta');
    } else if (response.statusCode == 404) {
      throw Exception('Perfil no encontrado');
    } else {
      throw Exception('Error del servidor: ${response.statusCode}');
    }
  }

  /// ✅ Actualizar nombre y teléfono
  Future<bool> updateBasicProfile(String userId, String nombre, String telefono) async {
    final numericId = _validateUserId(userId);
    final url = Uri.parse('$baseUrl/profile/$numericId/basic');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nombre': nombre, 'telefono': telefono}),
    );

    print('📤 PUT $url');
    print('📥 Response: ${response.statusCode}');

    return response.statusCode == 200;
  }

  /// ✅ Actualizar perfil completo
  Future<bool> updateUserProfile(UserModel user) async {
    final numericId = _validateUserId(user.id);
    final url = Uri.parse('$baseUrl/profile/$numericId');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    print('📤 PUT $url');
    print('📥 Response: ${response.statusCode}');
    return response.statusCode == 200;
  }

  /// ✅ CORREGIDO: Cambiar contraseña
  Future<bool> changePassword(String userId, String currentPassword, String newPassword) async {
    try {
      final numericId = _validateUserId(userId);
      
      // Obtener el token de autenticación
      final authStorage = AuthStorageService();
      final token = await authStorage.getToken();
      
      if (token == null) {
        throw Exception('Token de autenticación no encontrado');
      }

      // URL CORREGIDA - usar el endpoint correcto
      final url = Uri.parse('$baseUrl/profile/$numericId/password');
      
      print('📤 PUT: $url');
      print('📤 UserId: $numericId');
      print('📤 Token: ${token.substring(0, 20)}...');

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'oldPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      print('📥 Status: ${response.statusCode}');
      print('📥 Body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        throw Exception('Contraseña actual incorrecta');
      } else if (response.statusCode == 404) {
        throw Exception('Usuario no encontrado');
      } else {
        // Intentar obtener mensaje de error del backend
        try {
          final errorData = jsonDecode(response.body);
          final errorMessage = errorData['message'] ?? 
                              errorData['error'] ?? 
                              'Error del servidor: ${response.statusCode}';
          throw Exception(errorMessage);
        } catch (_) {
          throw Exception('Error del servidor: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('❌ Error en changePassword: $e');
      rethrow;
    }
  }

  /// ✅ Eliminar cuenta
  Future<bool> deleteUserAccount(String userId) async {
    final numericId = _validateUserId(userId);
    final url = Uri.parse('$baseUrl/$numericId');

    final response = await http.delete(url, headers: ApiConfig.defaultHeaders);

    print('🗑️ DELETE $url');
    print('📥 Response: ${response.statusCode}');
    return response.statusCode == 200;
  }
}