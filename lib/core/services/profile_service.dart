import 'dart:convert';

import 'package:frontend_manteniapp/core/network/api_config.dart';
import 'package:frontend_manteniapp/core/services/auth_storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend_manteniapp/features/perfil_usuario/data/datasources/perfil_remote_datasource.dart';
import 'package:frontend_manteniapp/features/perfil_usuario/data/models/user_model.dart';

class ProfileService {
  final String baseUrl = '${ApiConfig.baseUrl}/users';
  final PerfilRemoteDataSource _remoteDataSource = PerfilRemoteDataSource();

  Future<void> _debugStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final authStorage = AuthStorageService();
    
    print('🔍 === DEBUG STORAGE ===');
    final storageUserId = await authStorage.getUserId();
    final storageToken = await authStorage.getToken();
    
    print('🔍 AuthStorage - userId: $storageUserId');
    print('🔍 AuthStorage - token: ${storageToken != null ? "PRESENTE" : "AUSENTE"}');
    print('🔍 === FIN DEBUG ===');
  }

  Future<UserModel> getUserProfile() async {
    await _debugStorage();
    
    final authStorage = AuthStorageService();
    final userId = await authStorage.getUserId();

    if (userId == null || userId.isEmpty) {
      throw Exception('⚠️ No hay usuario autenticado');
    }

    return _remoteDataSource.getUserProfile(userId);
  }

  Future<bool> updateBasicProfile(String nombre, String telefono) async {
    final authStorage = AuthStorageService();
    final userId = await authStorage.getUserId();

    if (userId == null || userId.isEmpty) {
      throw Exception('⚠️ No hay usuario autenticado');
    }

    return _remoteDataSource.updateBasicProfile(userId, nombre, telefono);
  }

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      final token = prefs.getString('auth_token'); // ← Cambiar a 'auth_token'
      
      print('🔍 Debug - UserId: $userId');
      print('🔍 Debug - Token: $token');
      
      if (userId == null) {
        throw Exception('Usuario no autenticado (userId faltante)');
      }

      if (token == null || token.isEmpty) {
        // Intentar recuperar el token de AuthStorageService
        final authStorage = AuthStorageService();
        final storedToken = await authStorage.getToken();
        
        if (storedToken == null || storedToken.isEmpty) {
          throw Exception('Usuario no autenticado (token faltante). Por favor, inicie sesión nuevamente.');
        }
        
        // Actualizar en SharedPreferences
        await prefs.setString('auth_token', storedToken);
        print('✅ Token recuperado de AuthStorage: ${storedToken.substring(0, 20)}...');
      }

      final url = Uri.parse('${ApiConfig.baseUrl}/users/profile/$userId/password');
      
      print('📤 Cambiando contraseña: $url');
      print('📤 UserId: $userId');
      print('📤 Token length: ${token?.length ?? 0}');
      
      final finalToken = token ?? await AuthStorageService().getToken();
      
      if (finalToken == null) {
        throw Exception('No se pudo obtener el token de autenticación');
      }

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $finalToken',
        },
        body: jsonEncode({
          'oldPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ Contraseña cambiada exitosamente');
        return true;
      } else if (response.statusCode == 401) {
        throw Exception('Contraseña actual incorrecta o token inválido');
      } else if (response.statusCode == 404) {
        throw Exception('Usuario no encontrado');
      } else {
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

  Future<bool> deleteAccount() async {
    final authStorage = AuthStorageService();
    final userId = await authStorage.getUserId();

    if (userId == null || userId.isEmpty) {
      throw Exception('⚠️ No hay usuario autenticado');
    }

    return _remoteDataSource.deleteUserAccount(userId);
  }

  /// ✅ Obtener el userId directamente desde AuthStorage
  static Future<String?> getUserId() async {
    final authStorage = AuthStorageService();
    return await authStorage.getUserId();
  }
}