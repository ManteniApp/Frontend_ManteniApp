import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

// Imports de nuestro feature
import 'features/motorcycles/presentation/providers/motorcycle_provider.dart';
import 'features/Register_User/presentation/pages/register_user.dart';
import 'features/motorcycles/domain/usecases/register_motorcycle.dart';
import 'features/motorcycles/data/repositories/motorcycle_repository_impl.dart';
import 'features/motorcycles/data/datasources/motorcycle_remote_data_source.dart';
import 'features/motorcycles/presentation/pages/register_motorcycle_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MotorcycleProvider(
            registerMotorcycleUseCase: RegisterMotorcycleUseCase(
              MotorcycleRepositoryImpl(
                remoteDataSource: MotorcycleRemoteDataSourceImpl(
                  client: http.Client(),
                  baseUrl: 'https://api.ejemplo.com', // Cambiar por tu API real
                ),
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
        ),
        home: const RegisterMotorcyclePage(),
      ),
    );
  }
}
