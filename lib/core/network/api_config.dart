class ApiConfig {
  // ⚠️ IMPORTANTE: Cambiar esta URL según tu entorno
  // Para desarrollo local (Chrome/Web): 'http://localhost:3000'
  // Para emulador Android: 'http://10.0.2.2:3000'
  // Para dispositivo físico: 'http://TU_IP_LOCAL:3000'
  // Para producción: 'https://tu-api.com'
  static const String baseUrl = 'http://localhost:3000';

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

  // Endpoints de historial de mantenimientos
  static const String maintenanceHistoryEndpoint = '/maintenance';

  // Endpoints de reporte de mantenimientos
  static const String maintenanceSummaryEndpoint = '/maintenance-summary';
  static const String maintenanceSummaryPdfEndpoint =
      '/maintenance-summary/pdf';

  // Timeouts (⚠️ TEMPORALMENTE aumentado para debug - backend muy lento)
  static const Duration connectionTimeout = Duration(seconds: 60);
  static const Duration receiveTimeout = Duration(seconds: 60);

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
