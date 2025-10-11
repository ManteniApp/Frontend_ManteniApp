import 'package:flutter/material.dart';
import 'core/layout/main_layout.dart';

void main() {
  runApp(const ManteniApp());
}

class ManteniApp extends StatelessWidget {
  const ManteniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ManteniApp',
      theme: ThemeData(useMaterial3: true, fontFamily: 'Poppins'),
      home: const MainLayout(),
    );
  }
}
