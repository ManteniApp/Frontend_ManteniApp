import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:frontend_manteniapp/features/perfil_usuario/presentation/pages/perfil_user.dart';
import 'package:provider/provider.dart';

// Imports de nuestro feature
import 'features/motorcycles/presentation/providers/motorcycle_provider.dart';
import 'features/motorcycles/domain/usecases/register_motorcycle.dart';
import 'features/motorcycles/domain/usecases/get_all_motorcycles.dart';
import 'features/motorcycles/data/repositories/motorcycle_repository_impl.dart';
import 'features/motorcycles/data/datasources/motorcycle_remote_data_source.dart';
import 'features/maintenance_history/presentation/providers/maintenance_history_provider.dart';
import 'features/maintenance_history/domain/usecases/get_maintenance_history.dart';
import 'features/maintenance_history/domain/usecases/update_maintenance.dart';
import 'features/maintenance_history/domain/usecases/delete_maintenance.dart';
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
          create: (context) {
            final motorcycleRepository = MotorcycleRepositoryImpl(
              remoteDataSource: MotorcycleRemoteDataSourceImpl(),
            );
            return MotorcycleProvider(
              registerMotorcycleUseCase: RegisterMotorcycleUseCase(
                motorcycleRepository,
              ),
              getAllMotorcyclesUseCase: GetAllMotorcycles(motorcycleRepository),
            );
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            final repository = MaintenanceHistoryRepositoryImpl(
              remoteDataSource: MaintenanceHistoryRemoteDataSourceImpl(),
            );
            return MaintenanceHistoryProvider(
              getMaintenanceHistoryUseCase: GetMaintenanceHistory(repository),
              updateMaintenanceUseCase: UpdateMaintenance(repository),
              deleteMaintenanceUseCase: DeleteMaintenance(repository),
            );
          },
        ),
      ],
      child: MaterialApp(
        title: 'ManteniApp',
        debugShowCheckedModeBanner: false,
        // Configuración de localizaciones en español
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('es', 'ES'), // Español
        ],
        locale: const Locale('es', 'ES'),
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
          '/maintenance-history': (context) => const MaintenanceHistoryPage(),
          '/perfil': (context) => PerfilUser()
        },
      ),
    );
  }
}
