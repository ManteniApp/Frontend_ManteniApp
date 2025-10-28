// core/services/google_auth_service.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:frontend_manteniapp/core/network/api_config.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class GoogleAuthService {
  static const String _baseUrl = '${ApiConfig.baseUrl}/users';
  
  // Para Android, usa esta configuración
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    // No especifiques clientId para Android si usas google-services.json
  );

  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      print('🔄 Iniciando Google Sign-In...');
      
      // Verificar si tenemos el archivo de configuración
      await _verifyConfiguration();
      
      await _googleSignIn.signOut();
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        throw Exception('El usuario canceló el inicio de sesión');
      }

      print('✅ Usuario de Google: ${googleUser.displayName}');
      print('✅ Email: ${googleUser.email}');
      print('✅ ID: ${googleUser.id}');

      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      final String? idToken = googleAuth.idToken;
      
      if (idToken == null) {
        throw Exception('No se pudo obtener el token de ID de Google');
      }

      print('🔑 ID Token obtenido (primeros 100 chars): ${idToken.substring(0, 100)}...');

      // Enviar el token al backend
      final response = await http.post(
        Uri.parse('$_baseUrl/google'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'idToken': idToken,
        }),
      ).timeout(const Duration(seconds: 30));

      print('📡 Respuesta del backend - Status: ${response.statusCode}');
      print('📡 Respuesta del backend - Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        await _saveUserData(responseData);
        print('🎉 ¡Login con Google exitoso!');
        return responseData;
      } else {
        print('❌ Error del servidor: ${response.statusCode}');
        throw Exception('Error del servidor: ${response.statusCode} - ${response.body}');
      }
    } on PlatformException catch (e) {
      print('❌ PlatformException: ${e.code} - ${e.message}');
      print('❌ Details: ${e.details}');
      print('❌ Stacktrace: ${e.stacktrace}');
      
      // Manejo específico para error 10
      if (e.code == 'sign_in_failed' && e.message?.contains('10') == true) {
        throw Exception(
          'Error de configuración de Firebase. '
          'Verifica que:\n'
          '1. google-services.json esté en android/app/\n'
          '2. El package name coincida\n'
          '3. Firebase esté configurado correctamente en el proyecto'
        );
      }
      
      throw Exception(_parsePlatformException(e));
    } catch (e) {
      print('❌ Error en Google Sign-In: $e');
      rethrow;
    }
  }

  Future<void> _verifyConfiguration() async {
    print('🔍 Verificando configuración de Google Sign-In...');
    print('📱 Package: com.example.frontend_manteniapp');
    print('🔧 Usando google-services.json para configuración automática');
    
    // Verificar que estamos en Android
    print('📲 Platform: Android');
  }

  String _parsePlatformException(PlatformException e) {
    switch (e.code) {
      case 'sign_in_failed':
        if (e.message?.contains('10') == true) {
          return 'Error de configuración de Firebase (Error 10). '
                 'La persona que configura Firebase debe verificar:\n'
                 '• SHA-1 fingerprint en Firebase Console\n'
                 '• Package name: com.example.frontend_manteniapp\n'
                 '• Google Sign-In habilitado en Authentication';
        }
        return 'Error en el inicio de sesión: ${e.message}';
      case 'sign_in_canceled':
        return 'Inicio de sesión cancelado por el usuario';
      case 'network_error':
        return 'Error de red. Verifica tu conexión a internet';
      default:
        return 'Error: ${e.message}';
    }
  }

  Future<void> _saveUserData(Map<String, dynamic> responseData) async {
    final prefs = await SharedPreferences.getInstance();
    
    if (responseData['accessToken'] != null) {
      await prefs.setString('auth_token', responseData['accessToken']);
      print('✅ Token de acceso guardado');
    }
    
    if (responseData['user'] != null) {
      final user = responseData['user'];
      if (user['id'] != null) {
        await prefs.setString('userId', user['id'].toString());
        print('✅ UserId guardado: ${user['id']}');
      }
      
      if (user['email'] != null) {
        await prefs.setString('userEmail', user['email']);
        print('✅ Email guardado: ${user['email']}');
      }
      
      if (user['nombre'] != null) {
        await prefs.setString('userName', user['nombre']);
        print('✅ Nombre guardado: ${user['nombre']}');
      }
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('userId');
    await prefs.remove('userEmail');
    await prefs.remove('userName');
    print('✅ Sesión de Google cerrada');
  }

  Future<bool> isSignedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token != null && token.isNotEmpty;
  }

  Future<void> debugGoogleSignIn() async {
    try {
      print('🔍 Debug Google Sign-In Configuration:');
      print('📱 Package Name: com.example.frontend_manteniapp');
      print('🔑 Client ID: 347009076875-1uddg0vdqd4h6m5dnr175v3qfhmb1ld4.apps.googleusercontent.com');
      print('🌐 API Key: AIzaSyDpLhTyCFxL-O-O9nDO-N3tyMNNQVouv2Y');
      
      // Verificar si Google Play Services está disponible
      final isAvailable = await GoogleSignIn().isSignedIn();
      print('📲 Google Play Services disponible: $isAvailable');
    } catch (e) {
      print('❌ Error en debug: $e');
    }
  }
}