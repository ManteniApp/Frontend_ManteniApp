import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Imports de nuestro feature
import 'features/motorcycles/presentation/providers/motorcycle_provider.dart';
import 'features/motorcycles/domain/usecases/register_motorcycle.dart';
import 'features/motorcycles/data/repositories/motorcycle_repository_impl.dart';
import 'features/motorcycles/data/datasources/motorcycle_remote_data_source.dart';
import 'core/layout/main_layout.dart';

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
        home: const MainLayout(),
      ),
    );
  }
}
