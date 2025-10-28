import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:frontend_manteniapp/core/services/google_auth_service.dart';
import 'package:frontend_manteniapp/features/auth_1/presentation/widgets/customButton.dart';
import 'package:frontend_manteniapp/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:frontend_manteniapp/core/services/auth_service.dart';
import 'package:frontend_manteniapp/features/auth_1/presentation/widgets/forgot_password_page.dart';
import 'package:frontend_manteniapp/features/auth_1/presentation/widgets/reset_password_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  final GoogleAuthService _googleAuthService = GoogleAuthService();
  final AppLinks _appLinks = AppLinks(); 

  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  
  

  @override
  void initState() {
    super.initState();
    _checkDeepLinks(); // Agregar esto
  }
  void _checkDeepLinks() async {
     try {
      final prefs = await SharedPreferences.getInstance();
      final deepLinkHandled = prefs.getBool('deepLinkHandled') ?? false;
      
      // Si ya se manejó un deep link en los últimos 5 segundos, ignorar
      if (deepLinkHandled) {
        print('🔗 Deep link ya fue manejado recientemente, ignorando...');
        // Resetear el flag después de un tiempo
        Future.delayed(const Duration(seconds: 5), () {
          prefs.setBool('deepLinkHandled', false);
        });
        return;
      }

      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        await _handleDeepLink(initialUri.toString());
      }

      
      _appLinks.uriLinkStream.listen((Uri uri) async {
        await _handleDeepLink(uri.toString());
      });
    } catch (e) {
      print('❌ Error en deep links: $e');
    }
  }

  Future<void> _handleDeepLink(String link) async {
    print('🔗 Deep link recibido: $link');
    
    final prefs = await SharedPreferences.getInstance();
    
    // Marcar como manejado inmediatamente
    await prefs.setBool('deepLinkHandled', true);
    
    
    // Extraer token manualmente
    final token = _extractTokenFromLink(link);
    if (token != null && token.isNotEmpty && mounted) {
      print('✅ Navegando a reset password con token: $token');
      
      if (mounted) {
        // Navegar a la pantalla de reset password
        WidgetsBinding.instance.addPostFrameCallback((_) {
          print('🚀 Navegando a ResetPasswordPage...');
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => ResetPasswordPage(token: token),
            ),
            (route) => false,
          );
        });
      }
    } else {
      print('❌ No se pudo extraer token del link');
    }
  }

  String? _extractTokenFromLink(String link) {
    try {
      final uri = Uri.parse(link);
      
      // Para links como: http://192.168.0.20/reset-password?token=abc123
      if (uri.path == '/reset-password') {
        final token = uri.queryParameters['token'];
        if (token != null && token.isNotEmpty) {
          print('✅ Token encontrado en query: $token');
          return token;
        }
      }
      
      // Para links como: http://192.168.0.20/reset-password/abc123
      if (uri.path.startsWith('/reset-password/')) {
        final segments = uri.pathSegments;
        if (segments.length >= 2) {
          final token = segments[1];
          if (token.isNotEmpty) {
            print('✅ Token encontrado en path: $token');
            return token;
          }
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    print('✅ LoginPage se está construyendo'); // ← Agregar esto
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🟦 Logo y nombre de la app
              Image.asset('assets/img/logo.png', width: 150, height: 150),
              const SizedBox(height: 10),

              const Text.rich(
                TextSpan(
                  text: 'Manteni',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: 'App',
                      style: TextStyle(color: Color(0xFF1E88E5)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              const Text.rich(
                TextSpan(
                  text: 'Cuida ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E88E5),
                  ),
                  children: [
                    TextSpan(
                      text: 'lo que te',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: '\nmueve',
                      style: TextStyle(color: Color(0xFF1E88E5)),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // 🟦 Cajón con los campos y botones
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1E88E5).withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Inicia Sesión',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),

                    // 🟦 Campo usuario
                    CustomTextField(
                      hintText: "Usuario",
                      icon: Icons.person,
                      controller: userController,
                    ),
                    const SizedBox(height: 10),

                    // 🟦 Campo contraseña con ícono de ojo
                    TextField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: "Contraseña",
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 🟦 Enlace "Forgot password?" alineado a la derecha
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                          );
                        },
                        child: const Text(
                          "Olvide mi contraseña",
                          style: TextStyle(color: Colors.lightBlueAccent),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                     // 🟦 Botón Iniciar sesión
                    CustomButton(
                      text: _isLoading ? "Iniciando..." : "Iniciar sesión",
                      icon: Icons.login,
                      color: const Color(0xFF1E88E5),
                      onPressed: _isLoading
                          ? null
                          : () {
                              _handleLogin();
                            },
                    ),
                    const SizedBox(height: 10),

                    // 🟦 Texto "Or continue with"
                    const Text(
                      'O continua con',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Botón de Google 
                    _isGoogleLoading
                        ? const CircularProgressIndicator()
                        : GestureDetector(
                            onTap: _handleGoogleSignIn,
                            child: Container(
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/img/google.png',
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 10),

                    // 🟦 Texto "Don't have an account? Sign up"
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "¿No tienes una cuenta? ",
                          style: TextStyle(color: Colors.black54),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: const Text(
                            " Regístrate",
                            style: TextStyle(
                              color: Color(0xFF1E88E5),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para manejar el inicio de sesión con Google
  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isGoogleLoading = true;
    });

    try {
      final result = await _googleAuthService.signInWithGoogle();
      
      if (!mounted) return;

      if (result != null && result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("¡Inicio de sesión con Google exitoso!"),
            backgroundColor: Colors.green,
          ),
        );

        // Navegar a home
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        throw Exception('No se pudo completar el inicio de sesión con Google');
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error en Google Sign-In: ${e.toString()}"),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleLoading = false;
        });
      }
    }
  }

  // Método para manejar el inicio de sesión normal (existente)
  Future<void> _handleLogin() async {
    final user = userController.text.trim();
    final pass = passwordController.text.trim();

    if (user.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Completa todos los campos"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final token = await _authService.login(user, pass);

      if (!mounted) return;

      if (token != null) {
        final userId = await _authService.getUserId();
        print('🔵 UserId desde AuthService: $userId');

        try {
          final response = await _authService.login(user, pass);
          print('🔵 Respuesta completa del login: $response');
        } catch (e) {
          print('🔵 Error al obtener respuesta completa: $e');
        }

        if (userId != null && userId.isNotEmpty && userId != 'null') {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('userId', userId);
          print('✅ UserId guardado en SharedPreferences: $userId');
        } else {
          print('❌ UserId es nulo, vacío o inválido: "$userId"');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("¡Bienvenido, $user!"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Credenciales incorrectas"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

 @override
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}