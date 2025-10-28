import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/network/api_config.dart';
import '../../core/network/api_client.dart';
import '../../core/services/auth_storage_service.dart';

class LoginResponse {
  final String accessToken;
  final String? userId;
  final Map<String, dynamic>? user;

  LoginResponse({required this.accessToken, this.userId, this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'] ?? json['token'] ?? '',
      userId: json['user']?['id']?.toString() ?? json['userId']?.toString(),
      user: json['user'],
    );
  }
}

class AuthService {
  final ApiClient _apiClient;
  final AuthStorageService _authStorage;

  AuthService({ApiClient? apiClient, AuthStorageService? authStorage})
    : _apiClient = apiClient ?? ApiClient(),
      _authStorage = authStorage ?? AuthStorageService();

  Future<String?> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        ApiConfig.loginEndpoint,
        body: {'email': email, 'password': password},
        requiresAuth: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final loginResponse = LoginResponse.fromJson(data);

        // Guardar token y datos del usuario
        await _authStorage.saveToken(loginResponse.accessToken);

        // ✅ CORREGIDO: Manejar correctamente el userId
        if (loginResponse.userId != null && loginResponse.userId!.isNotEmpty) {
          await _authStorage.saveUserId(loginResponse.userId!);
          print('✅ UserId guardado: ${loginResponse.userId}');
        } else if (loginResponse.user != null &&
            loginResponse.user!['id'] != null) {
          final userId = loginResponse.user!['id'].toString();
          await _authStorage.saveUserId(userId);
          print('✅ UserId guardado desde user object: $userId');
        } else {
          print('⚠️ No se pudo obtener userId de la respuesta');
        }

        await _authStorage.saveUserEmail(email);
        return loginResponse.accessToken;
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Error en login');
      }
    } catch (e) {
      print('❌ Error en login: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> register(Map<String, dynamic> userData) async {
    try {
      // ✅ Asegurar que los nombres de campos coincidan con el backend
      final Map<String, dynamic> formattedData = {
        'email': userData['email']?.toString().trim(),
        'password': userData['password']?.toString().trim(),
        'nombre': userData['username']
            ?.toString()
            .trim(), // ← CAMBIAR 'username' por 'nombre'
        'telefono': userData['phone']?.toString().trim(),
      };

      print('🔄 Registro con datos formateados: $formattedData');

      final response = await _apiClient.post(
        ApiConfig.registerEndpoint,
        body: formattedData, // ← Usar los datos formateados
        requiresAuth: false,
      );

      print('📥 Respuesta registro: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);

        // Guardar token e ID después del registro
        if (data['accessToken'] != null) {
          await _authStorage.saveToken(data['accessToken']);
          print('✅ Token guardado después del registro');
        }

        if (data['user']?['id'] != null) {
          await _authStorage.saveUserId(data['user']['id'].toString());
          print(
            '✅ UserId guardado después del registro: ${data['user']['id']}',
          );
        }

        return data;
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          errorData['message'] ?? 'Error en registro: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('❌ Error en registro: $e');
      rethrow;
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      final url = Uri.parse(
        '${ApiConfig.baseUrl}/users/password/forgot?frontendUrl=http://localhost',
      );

      print('📧 Enviando recuperación para: $email');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      print('🔵 Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          print('✅ Correo enviado exitosamente');
          return;
        } else {
          throw Exception('Error del servidor: ${response.body}');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          errorData['message'] ?? 'Error HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      print('❌ Error en forgotPassword: $e');
      rethrow;
    }
  }

  Future<void> resetPassword(String token, String newPassword) async {
    try {
      final response = await _apiClient.post(
        ApiConfig.resetPasswordEndpoint,
        body: {'token': token, 'newPassword': newPassword},
        requiresAuth: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Contraseña cambiada exitosamente');
        return;
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Error al cambiar contraseña');
      }
    } catch (e) {
      print('❌ Error en resetPassword: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    await _authStorage.clearAuth();
  }

  Future<bool> isAuthenticated() async {
    return await _authStorage.isAuthenticated();
  }

  Future<String?> getToken() async {
    return await _authStorage.getToken();
  }

  Future<String?> getUserId() async {
    return await _authStorage.getUserId();
  }

  Future<String?> getUserEmail() async {
    return await _authStorage.getUserEmail();
  }
}
