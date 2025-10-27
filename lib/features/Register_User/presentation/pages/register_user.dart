import 'package:flutter/material.dart';
import 'package:frontend_manteniapp/features/motorcycles/presentation/widgets/simple_form_field.dart';
import '../controller/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? email;
  String? password;
  String? nombre;
  String? phone;

  final AuthController _authController = AuthController();
  bool _obscurePassword = true;

  // ✅ Funciones de validación
  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= 6;
  }

  bool _isValidPhone(String phone) {
    final regex = RegExp(r'^[0-9]{7,15}$'); // Solo números, entre 7 y 15 dígitos
    return regex.hasMatch(phone);
  }

  void _showSnack(String message, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.redAccent : Colors.green,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: Image.asset(
              'assets/images/logoMA.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF007AFF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.build, color: Colors.white, size: 18),
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'ManteniApp',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(top: 40, left: 0, right: 0, child: _buildHeader(context)),

            Positioned(
              top: 70,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  'assets/images/logoRegistro.png',
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            Positioned(
              top: 350,
              left: 0,
              right: 0,
              child: Container(
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Regístrate',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Campos
                    SimpleFormField(
                      icon: Icons.mail,
                      label: 'Correo',
                      value: email,
                      onTap: () async {
                        final result = await SelectionBottomSheet.showTextInput(
                          context: context,
                          title: 'Correo electrónico',
                          hint: 'Ingresa tu correo',
                        );
                        if (result != null && result.isNotEmpty) {
                          setState(() => email = result);
                        }
                      },
                    ),

                    SimpleFormField(
                      icon: Icons.lock,
                      label: 'Contraseña',
                      value: password != null && password!.isNotEmpty
                          ? (_obscurePassword ? '••••••••' : password)
                          : '',
                      onTap: () async {
                        final result = await SelectionBottomSheet.showTextInput(
                          context: context,
                          title: 'Contraseña',
                          hint: 'Ingresa tu contraseña',
                        );
                        if (result != null && result.isNotEmpty) {
                          setState(() => password = result);
                        }
                      },
                    ),

                    SimpleFormField(
                      icon: Icons.person,
                      label: 'Usuario',
                      value: nombre,
                      onTap: () async {
                        final result = await SelectionBottomSheet.showTextInput(
                          context: context,
                          title: 'Nombre de usuario',
                          hint: 'Ingresa tu usuario',
                        );
                        if (result != null && result.isNotEmpty) {
                          setState(() => nombre = result);
                        }
                      },
                    ),

                    SimpleFormField(
                      icon: Icons.phone,
                      label: 'Teléfono',
                      value: phone,
                      onTap: () async {
                        final result = await SelectionBottomSheet.showTextInput(
                          context: context,
                          title: 'Número de teléfono',
                          hint: 'Ingresa tu número',
                          keyboardType: TextInputType.phone,
                        );
                        if (result != null && result.isNotEmpty) {
                          setState(() => phone = result);
                        }
                      },
                    ),

                    const SizedBox(height: 25),

                    // Botón de registro con validaciones
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (email == null ||
                            password == null ||
                            nombre == null ||
                            phone == null) {
                          _showSnack('Por favor completa todos los campos', error: true);
                          return;
                        }

                        if (!_isValidEmail(email!)) {
                          _showSnack('Correo electrónico inválido', error: true);
                          return;
                        }

                        if (!_isValidPassword(password!)) {
                          _showSnack('La contraseña debe tener al menos 6 caracteres', error: true);
                          return;
                        }

                        if (!_isValidPhone(phone!)) {
                          _showSnack('Número de teléfono inválido', error: true);
                          return;
                        }

                        // Llamada al backend
                        final response = await _authController.register(
                          email!,
                          password!,
                          nombre!,
                          phone!,
                        );

                        if (response != null && response.containsKey('user')) {
                          _showSnack('✅ Usuario registrado con éxito');
                          Navigator.pushNamed(context, '/register-motorcycle');
                        } else {
                          _showSnack('❌ Error al registrar el usuario', error: true);
                        }
                      },
                      icon: const Icon(Icons.person_add),
                      label: const Text("Registrarse"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E88E5),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
