import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:frontend_manteniapp/core/services/google_auth_service.dart';
import 'package:frontend_manteniapp/features/auth_1/presentation/widgets/customButton.dart';
import 'package:frontend_manteniapp/features/auth_1/presentation/widgets/custom_text_field.dart';
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
  GoogleAuthService? _googleAuthService;
  final AppLinks _appLinks = AppLinks();

  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  
  // Variables para manejar errores de validación
  String? _userError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    print('🚀 LoginPage initState ejecutándose');
  }

  // Método para validar el formato del correo electrónico
  String? _validateEmail(String email) {
    if (email.isEmpty) {
      return 'El correo electrónico es requerido';
    }
    
    // Expresión regular para validar formato de email
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    );
    
    if (!emailRegex.hasMatch(email)) {
      return 'Ingresa un correo electrónico válido';
    }
    
    return null;
  }

  // Método para validar la contraseña
  String? _validatePassword(String password) {
    if (password.isEmpty) {
      return 'La contraseña es requerida';
    }
    
    if (password.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    
    return null;
  }

  // Método para validar usuario (puede ser email o nombre de usuario)
  String? _validateUser(String user) {
    if (user.isEmpty) {
      return 'El usuario es requerido';
    }
    
    // Si parece ser un email, validar formato de email
    if (user.contains('@')) {
      return _validateEmail(user);
    }
    
    // Validación para nombre de usuario
    if (user.length < 3) {
      return 'El usuario debe tener al menos 3 caracteres';
    }
    
    return null;
  }

  // Método para limpiar errores
  void _clearErrors() {
    setState(() {
      _userError = null;
      _passwordError = null;
    });
  }

  // Método para validar todos los campos
  bool _validateForm() {
    _clearErrors();
    
    final userError = _validateUser(userController.text.trim());
    final passwordError = _validatePassword(passwordController.text.trim());
    
    setState(() {
      _userError = userError;
      _passwordError = passwordError;
    });
    
    return userError == null && passwordError == null;
  }

   // ignore: unused_element
   void _checkDeepLinks() async {
    print('🔗 Iniciando verificación de deep links');
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

      
      if (uri.path == '/reset-password') {
        final token = uri.queryParameters['token'];
        if (token != null && token.isNotEmpty) {
          print('✅ Token encontrado en query: $token');
          return token;
        }
      }

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🟦 Logo y nombre de la app
              Image.asset(
                'assets/img/logo.png',
                width: 150,
                height: 150,
                errorBuilder: (context, error, stackTrace) {
                  print('❌ Error cargando logo: $error');
                  return const Icon(Icons.error, size: 150, color: Colors.red);
                },
              ),
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
                    const SizedBox(height: 20),

                    // 🟦 Campo usuario con validación
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          hintText: "Usuario o correo electrónico",
                          icon: Icons.person,
                          controller: userController,
                          onChanged: (value) {
                            // Limpiar error cuando el usuario empiece a escribir
                            if (_userError != null) {
                              setState(() {
                                _userError = null;
                              });
                            }
                          },
                        ),
                        if (_userError != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 16, top: 4),
                            child: Text(
                              _userError!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // 🟦 Campo contraseña con validación
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: passwordController,
                          obscureText: _obscurePassword,
                          onChanged: (value) {
                            // Limpiar error cuando el usuario empiece a escribir
                            if (_passwordError != null) {
                              setState(() {
                                _passwordError = null;
                              });
                            }
                          },
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
                            errorText: _passwordError,
                          ),
                        ),
                        if (_passwordError != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 16, top: 4),
                            child: Text(
                              _passwordError!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // 🟦 Enlace "Forgot password?" alineado a la derecha
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgotPasswordPage(),
                            ),
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
                      style: TextStyle(color: Colors.black54, fontSize: 14),
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
      // ✅ Inicialización lazy de GoogleAuthService
      _googleAuthService ??= GoogleAuthService();

      final result = await _googleAuthService!.signInWithGoogle();

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

    if (!_validateForm()) {
      return; // Detener si hay errores de validación
    }

    final user = userController.text.trim();
    final pass = passwordController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      print('🔵 Intentando login con usuario: $user');
      
      final token = await _authService.login(user, pass);

      if (!mounted) return;

      if (token != null) {
        final userId = await _authService.getUserId();
        print('🔵 UserId desde AuthService: $userId');

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
      }
    } catch (e) {
      if (!mounted) return;

      print('❌ Error en login: $e');
      
      // Manejo ESPECÍFICO de errores
      final errorString = e.toString();
      
      if (errorString.contains('USER_NOT_FOUND')) {
        setState(() {
          _userError = 'Usuario no encontrado';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Usuario no encontrado. Verifica tu correo electrónico."),
            backgroundColor: Colors.orange,
          ),
        );
      } else if (errorString.contains('INCORRECT_PASSWORD')) {
        setState(() {
          _passwordError = 'Contraseña incorrecta';
        });
      } else {
        // Manejo de otros errores
        String errorMessage = "Error al iniciar sesión";
        
        if (errorString.contains('timeout') || errorString.contains('SocketException')) {
          errorMessage = "Error de conexión. Verifica tu internet";
        } else if (errorString.contains('SERVER_ERROR')) {
          errorMessage = "Error del servidor. Intenta más tarde";
        } else {
          errorMessage = errorString.replaceAll('Exception: ', '');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
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
