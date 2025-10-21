import 'package:flutter/material.dart';
import 'package:frontend_manteniapp/features/auth/presentation/widgets/customButton.dart';
import 'package:frontend_manteniapp/features/auth/presentation/widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true; // Controla si la contraseña está oculta

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
                      style: TextStyle(
                        color: Color(0xFF1E88E5),
                      ),
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
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\nmueve',
                      style: TextStyle(
                        color: Color(0xFF1E88E5),
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

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
                    const SizedBox(height: 30),

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
                    const SizedBox(height: 20),

                    // 🟦 Botón Iniciar sesión
                    CustomButton(
                      text: "Iniciar sesión",
                      icon: Icons.login,
                      color: const Color(0xFF1E88E5),
                      onPressed: () {
                        final user = userController.text;
                        final pass = passwordController.text;

                        if (user.isEmpty || pass.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Completa todos los campos"),
                            ),
                          );
                          return;
                        }

                        Navigator.pushNamed(context, '/home');
                      },
                    ),
                    const SizedBox(height: 20),

                    // 🟦 Botón de Google
                    GestureDetector(
                      onTap: () {
                        // Aquí iría la lógica de login con Google
                      },
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
                            'assets/img/google.png', // Asegúrate de tener esta imagen
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 🟦 Botón Registrarse
                    CustomButton(
                      text: "Registrarse",
                      icon: Icons.person_add,
                      color: const Color.fromARGB(255, 230, 230, 230),
                      textColor: const Color(0xFF1E88E5),
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                    ),
                    const SizedBox(height: 10),

                    // 🟦 Enlace “Olvidé mi contraseña”
                    Center(
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Olvidé mi contraseña",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
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
}