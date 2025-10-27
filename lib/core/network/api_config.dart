class ApiConfig {
  // ⚠️ IMPORTANTE: Cambiar esta URL según tu entorno
  // Para desarrollo local: 'http://localhost:3000'
  // Para emulador Android: 'http://10.0.2.2:3000'
  // Para dispositivo físico: 'http://TU_IP_LOCAL:3000'
  // Para producción: 'https://tu-api.com'
  static const String baseUrl = 'http://192.168.0.20:3000';

  // Endpoints de autenticación
  static const String loginEndpoint = '/users/login';
  static const String registerEndpoint = '/users/register';
  static const String googleLoginUrlEndpoint = '/users/google/login/url';
  static const String googleLoginCallbackEndpoint =
      '/users/google/login/callback';
  static const String forgotPasswordEndpoint = '/users/password/forgot';
  static const String resetPasswordEndpoint = '/users/password/reset';

  // Endpoints de motocicletas
  static const String motorcyclesEndpoint = '/motorcycles';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Headers comunes
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Método para obtener headers con autenticación
  static Map<String, String> getAuthHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };
}
