import 'package:app_links/app_links.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

class DeepLinkService {
  final AppLinks _appLinks = AppLinks();

  // Método simple para obtener y procesar deep links
  Future<void> handleDeepLinks(Function(String) onDeepLinkReceived) async {
    try {
      // 1. Obtener link inicial con app_links
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        final link = initialUri.toString();
        debugPrint('🔗 Initial deep link: $link');
        onDeepLinkReceived(link);
      }

      // 2. Escuchar links futuros con app_links
      _appLinks.uriLinkStream.listen((Uri uri) {
        final link = uri.toString();
        debugPrint('🔗 New deep link: $link');
        onDeepLinkReceived(link);
      });
    } catch (e) {
      debugPrint('❌ Error setting up deep links: $e');
    }
  }

  // Método para extraer el token del link de recuperación
  String? extractTokenFromResetLink(String link) {
    try {
      final uri = Uri.parse(link);
      debugPrint('🔗 Parsing reset link: $uri');
      
      // Para links con query parameter: ?token=abc123
      if (uri.path == '/reset-password') {
        final token = uri.queryParameters['token'];
        if (token != null && token.isNotEmpty) {
          debugPrint('✅ Token encontrado: $token');
          return token;
        }
      }
      
      // Para links con token en el path: /reset-password/abc123
      if (uri.path.startsWith('/reset-password/')) {
        final segments = uri.pathSegments;
        if (segments.length >= 2) {
          final token = segments[1]; // /reset-password/token123
          if (token.isNotEmpty) {
            debugPrint('✅ Token encontrado en path: $token');
            return token;
          }
        }
      }
      
      debugPrint('❌ Formato de link no reconocido');
      return null;
    } catch (e) {
      debugPrint('❌ Error parsing reset link: $e');
      return null;
    }
  }
}