import 'package:flutter/material.dart';
import 'package:frontend_manteniapp/features/motorcycles/presentation/widgets/simple_form_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? email;
  String? password;
  String? username;
  String? phone;

  bool _obscurePassword = true; // 👁️ estado para mostrar/ocultar contraseña

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
            // 🟦 Header independiente (logo pequeño + texto)
            Positioned(
              top: 40, // 🔽 ajusta este valor si lo quieres más abajo
              left: 0,
              right: 0,
              child: _buildHeader(context),
            ),

            // 🖼️ Imagen grande centrada arriba del contenedor
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

            // 🟩 Contenedor blanco con el formulario
            Positioned(
              top: 350, // 🔽 posición vertical del contenedor blanco
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

                    // 🟦 Campos
                    SimpleFormField(
                      icon: Icons.mail,
                      label: 'Correo',
                      value: email,
                      onTap: () async {
                        final result =
                            await SelectionBottomSheet.showTextInput(
                          context: context,
                          title: 'Correo electrónico',
                          hint: 'Ingresa tu correo',
                        );
                        if (result != null && result.isNotEmpty) {
                          setState(() => email = result);
                        }
                      },
                    ),

                    // 🟩 Campo de contraseña con ojito
                    SimpleFormField(
                      icon: Icons.lock,
                      label: 'Contraseña',
                      value: password != null && password!.isNotEmpty
                          ? (_obscurePassword ? '••••••••' : password)
                          : '',
                      onTap: () async {
                        final result =
                            await SelectionBottomSheet.showTextInput(
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
                      value: username,
                      onTap: () async {
                        final result =
                            await SelectionBottomSheet.showTextInput(
                          context: context,
                          title: 'Nombre de usuario',
                          hint: 'Ingresa tu usuario',
                        );
                        if (result != null && result.isNotEmpty) {
                          setState(() => username = result);
                        }
                      },
                    ),
                    SimpleFormField(
                      icon: Icons.phone,
                      label: 'Teléfono',
                      value: phone,
                      onTap: () async {
                        final result =
                            await SelectionBottomSheet.showTextInput(
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

                    // 🟦 Botón de registro
                    ElevatedButton.icon(
                      onPressed: () {
                        if (email == null ||
                            password == null ||
                            username == null ||
                            phone == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Por favor completa todos los campos'),
                            ),
                          );
                        } else {
                          Navigator.pushNamed(context, '/home');
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
