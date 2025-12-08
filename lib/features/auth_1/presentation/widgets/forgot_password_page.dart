import 'package:flutter/material.dart';
import 'package:frontend_manteniapp/core/services/auth_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _sendResetEmail() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      _showSnackBar('Por favor ingresa tu correo electrónico', Colors.orange);
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _showSnackBar('Por favor ingresa un correo electrónico válido', Colors.orange);
      return;
    }

    setState(() => _isLoading = true);

    try {
      print('🟡 INICIANDO ENVÍO DE CORREO PARA: $email');
      
      // ✅ Agregar más logs de debug
      print('🟡 Llamando a _authService.forgotPassword...');
      
      await _authService.forgotPassword(email);

      if (!mounted) return;
      
      print('✅ ÉXITO: Correo enviado correctamente');
      _showSnackBar('✅ Se ha enviado un enlace de recuperación a tu correo', Colors.green);
      
      // Limpiar el campo después del éxito
      emailController.clear();

    } catch (e) {
      print('🔴 ERROR CAPTURADO EN ForgotPasswordPage: $e');
      print('🔴 TIPO DE ERROR: ${e.runtimeType}');
      
      final errorStr = e.toString();
      print('🔴 CONTENIDO COMPLETO DEL ERROR: $errorStr');
      
      // ✅ MEJORAR el manejo de errores
      if (errorStr.contains('ok') || errorStr.contains('true') || errorStr.contains('201')) {
        _showSnackBar('✅ Se ha enviado un enlace de recuperación a tu correo', Colors.green);
        emailController.clear();
        return;
      }
      
      if (errorStr.contains('Exception: Error HTTP 404')) {
        _showSnackBar('❌ No existe una cuenta con este correo electrónico', Colors.red);
      } else if (errorStr.contains('Exception: Error HTTP 429')) {
        _showSnackBar('❌ Demasiados intentos. Espera unos minutos.', Colors.red);
      } else if (errorStr.contains('Exception: Error HTTP')) {
        _showSnackBar('❌ Error del servidor. Intenta más tarde.', Colors.red);
      } else if (errorStr.contains('SocketException') || errorStr.contains('Connection')) {
        _showSnackBar('❌ Error de conexión. Verifica tu internet.', Colors.red);
      } else {
        _showSnackBar('❌ Error: $errorStr', Colors.red);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Recuperar Contraseña',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icono e instrucciones
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E88E5).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_reset,
                        size: 40,
                        color: Color(0xFF1E88E5),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Ingresa tu correo electrónico y te enviaremos un enlace para restablecer tu contraseña.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Campo de email
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                  labelStyle: const TextStyle(color: Colors.black54),
                  prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF1E88E5)),
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF1E88E5), width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Botón de enviar
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _sendResetEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5),
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.send_outlined, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Enviar Enlace',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Botón de regresar
              SizedBox(
                width: double.infinity,
                height: 50,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF1E88E5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Regresar al Login',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}