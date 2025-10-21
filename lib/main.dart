import 'package:flutter/material.dart';
import 'package:frontend_manteniapp/features/auth_1/presentation/pages/login_page.dart';
import 'package:frontend_manteniapp/features/splah/presentation/pages/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ManteniApp',
      theme: ThemeData(primarySwatch: Colors.blue),
      // Pantalla inicial
      home: const SplashScreen(),
      // Rutas de navegación
      routes: {
        '/login': (context) => LoginPage(),
      },
    );
  }
}
