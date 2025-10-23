import 'dart:convert';
import '../../core/network/api_config.dart';
import '../../core/network/api_client.dart';
import '../../core/services/auth_storage_service.dart';

/// Modelo de respuesta del login
class LoginResponse {
  final String accessToken;
  final String? userId;
  final Map<String, dynamic>? user;

  LoginResponse({required this.accessToken, this.userId, this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken:
          json['access_token'] ?? json['accessToken'] ?? json['token'] ?? '',
      userId: json['userId']?.toString() ?? json['user']?['id']?.toString(),
      user: json['user'],
    );
  }
}

/// Servicio de autenticación
///
/// Maneja el login, registro y almacenamiento del token JWT
class AuthService {
  final ApiClient _apiClient;
  final AuthStorageService _authStorage;

  AuthService({ApiClient? apiClient, AuthStorageService? authStorage})
    : _apiClient = apiClient ?? ApiClient(),
      _authStorage = authStorage ?? AuthStorageService();

  /// Realiza el login y guarda el token
  ///
  /// Retorna el token JWT si el login es exitoso, null en caso contrario
  Future<String?> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        ApiConfig.loginEndpoint,
        body: {'email': email, 'password': password},
        requiresAuth: false, // El login no requiere autenticación previa
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final loginResponse = LoginResponse.fromJson(data);

        // Guardar el token
        await _authStorage.saveToken(loginResponse.accessToken);

        // Guardar información adicional del usuario si está disponible
        if (loginResponse.userId != null) {
          await _authStorage.saveUserId(loginResponse.userId!);
        }
        await _authStorage.saveUserEmail(email);

        return loginResponse.accessToken;
      } else {
        print('❌ Error en login: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Error de conexión en login: $e');
      return null;
    }
  }

  /// Registra un nuevo usuario
  Future<bool> register(Map<String, dynamic> userData) async {
    try {
      final response = await _apiClient.post(
        ApiConfig.registerEndpoint,
        body: userData,
        requiresAuth: false,
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('❌ Error en registro: $e');
      return false;
    }
  }

  /// Cierra la sesión del usuario
  Future<void> logout() async {
    await _authStorage.clearAuth();
  }

  /// Verifica si el usuario está autenticado
  Future<bool> isAuthenticated() async {
    return await _authStorage.isAuthenticated();
  }

  /// Obtiene el token actual
  Future<String?> getToken() async {
    return await _authStorage.getToken();
  }

  /// Obtiene el ID del usuario actual
  Future<String?> getUserId() async {
    return await _authStorage.getUserId();
  }

  /// Obtiene el email del usuario actual
  Future<String?> getUserEmail() async {
    return await _authStorage.getUserEmail();
  }
}
