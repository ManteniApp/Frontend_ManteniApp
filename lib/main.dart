import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Imports de nuestro feature
import 'features/motorcycles/presentation/providers/motorcycle_provider.dart';
import 'features/motorcycles/domain/usecases/register_motorcycle.dart';
import 'features/motorcycles/data/repositories/motorcycle_repository_impl.dart';
import 'features/motorcycles/data/datasources/motorcycle_remote_data_source.dart';
import 'core/layout/main_layout.dart';
import 'features/auth_1/presentation/pages/login_page.dart';
import 'features/Register_User/presentation/pages/register_user.dart';
import 'features/motorcycles/presentation/pages/register_motorcycle_page.dart';

void main() {
  runApp(const ManteniApp());
}

class ManteniApp extends StatelessWidget {
  const ManteniApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MotorcycleProvider(
            registerMotorcycleUseCase: RegisterMotorcycleUseCase(
              MotorcycleRepositoryImpl(
                remoteDataSource: MotorcycleRemoteDataSourceImpl(),
              ),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'ManteniApp',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          fontFamily: 'Poppins',
        ),
        // Pantalla inicial - LoginPage
        home: const LoginPage(),
        // Rutas de navegación
        routes: {
          '/home': (context) => const MainLayout(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/register-motorcycle': (context) => const RegisterMotorcyclePage(),
        },
      ),
    );
  }
}
