import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Servicio para almacenar y recuperar el token de autenticación de forma segura
///
/// Utiliza flutter_secure_storage para guardar el token de forma encriptada
class AuthStorageService {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';

  final FlutterSecureStorage _storage;

  AuthStorageService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  /// Guarda el token JWT
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Obtiene el token JWT guardado
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Guarda el ID del usuario
  Future<void> saveUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
  }

  /// Obtiene el ID del usuario
  Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  /// Guarda el email del usuario
  Future<void> saveUserEmail(String email) async {
    await _storage.write(key: _userEmailKey, value: email);
  }

  /// Obtiene el email del usuario
  Future<String?> getUserEmail() async {
    return await _storage.read(key: _userEmailKey);
  }

  /// Verifica si hay un token guardado
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Verifica si el usuario está autenticado
  Future<bool> isAuthenticated() async {
    return await hasToken();
  }

  /// Limpia todos los datos de autenticación (logout)
  Future<void> clearAuth() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userIdKey);
    await _storage.delete(key: _userEmailKey);
  }

  /// Limpia todo el storage
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
