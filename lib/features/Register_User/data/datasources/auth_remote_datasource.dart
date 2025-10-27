import 'dart:convert';
import 'package:frontend_manteniapp/core/network/api_config.dart';
import 'package:http/http.dart' as http;
import '../models/user_register_model.dart';

class AuthRemoteDataSource {
  
  Future<Map<String, dynamic>> register(UserRegisterModel user) async {
    final url = Uri.parse(
      '${ApiConfig.baseUrl}${ApiConfig.registerEndpoint}');
    
    try {
      final response = await http.post(
        url,
        headers: ApiConfig.defaultHeaders,
        body: jsonEncode(user.toJson()),
      );

      print('📤 Request: ${user.toJson()}');
      print('📥 Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data; // Retorna el objeto con user y token
      }

      throw Exception(
          'Error al registrar: ${response.statusCode} - ${response.body}');
    } catch (e) {
      print('❌ Error de conexión: $e');
      rethrow;
    }
  }
}