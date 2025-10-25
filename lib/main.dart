import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Imports de nuestro feature
import 'features/motorcycles/presentation/providers/motorcycle_provider.dart';
import 'features/motorcycles/domain/usecases/register_motorcycle.dart';
import 'features/motorcycles/data/repositories/motorcycle_repository_impl.dart';
import 'features/motorcycles/data/datasources/motorcycle_remote_data_source.dart';
import 'features/maintenance_history/presentation/providers/maintenance_history_provider.dart';
import 'features/maintenance_history/domain/usecases/get_maintenance_history.dart';
import 'features/maintenance_history/data/repositories/maintenance_history_repository_impl.dart';
import 'features/maintenance_history/data/datasources/maintenance_history_remote_data_source.dart';
import 'core/layout/main_layout.dart';
import 'features/auth_1/presentation/pages/login_page.dart';
import 'features/Register_User/presentation/pages/register_user.dart';
import 'features/motorcycles/presentation/pages/register_motorcycle_page.dart';
import 'features/maintenance_history/presentation/pages/maintenance_history_page.dart';

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
        ChangeNotifierProvider(
          create: (context) => MaintenanceHistoryProvider(
            getMaintenanceHistoryUseCase: GetMaintenanceHistory(
              MaintenanceHistoryRepositoryImpl(
                remoteDataSource: MaintenanceHistoryRemoteDataSourceImpl(),
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
        home: const MaintenanceHistoryPage(),
        // Rutas de navegación
        routes: {
          '/home': (context) => const MainLayout(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/register-motorcycle': (context) => const RegisterMotorcyclePage(),
          '/maintenance-history': (context) => const MaintenanceHistoryPage(),
        },
      ),
    );
  }
}
