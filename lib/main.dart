import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/list_motorcicle/presentation/pages/list_motorcycle_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ManteniApp',
      theme: AppTheme.lightTheme,
      home: const ListMotorcyclePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
