import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:frontend_manteniapp/features/perfil_usuario/presentation/pages/perfil_user.dart';
import 'package:frontend_manteniapp/features/register_maintenance/presentation/pages/maintenance_register_page.dart';
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
import 'features/maintenance_recommendations/presentation/providers/recommendation_provider.dart';
import 'features/maintenance_recommendations/domain/usecases/get_general_recommendations.dart';
import 'features/maintenance_recommendations/domain/usecases/get_motorcycle_recommendations.dart';
import 'features/maintenance_recommendations/domain/usecases/get_all_recommendations.dart';
import 'features/maintenance_recommendations/domain/usecases/get_technical_recommendations.dart';
import 'features/maintenance_recommendations/domain/usecases/get_safety_recommendations.dart';
import 'features/maintenance_recommendations/domain/usecases/get_performance_recommendations.dart';
import 'features/maintenance_recommendations/domain/usecases/get_recommendations_by_category.dart';
import 'features/maintenance_recommendations/domain/usecases/get_recommendations_by_priority.dart';
import 'features/maintenance_recommendations/domain/usecases/get_upcoming_recommendations.dart';
import 'features/maintenance_recommendations/domain/usecases/delete_recommendation.dart';
import 'features/maintenance_recommendations/data/repositories/recommendation_repository_impl.dart';
import 'features/maintenance_recommendations/data/datasources/recommendation_remote_data_source.dart';
import 'features/maintenance_recommendations/presentation/pages/maintenance_recommendations_page.dart';
import 'features/maintenance_recommendations/presentation/pages/test_recommendations_page.dart';
import 'core/layout/main_layout.dart';
import 'features/auth_1/presentation/pages/login_page.dart';
import 'features/Register_User/presentation/pages/register_user.dart';
import 'features/motorcycles/presentation/pages/register_motorcycle_page.dart';
import 'features/maintenance_history/presentation/pages/maintenance_history_page.dart';
import 'features/motorcycles/presentation/pages/edit_motorcycle_page.dart';
import 'features/motorcycles/data/models/motorcycle_model.dart';

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
        ChangeNotifierProvider(
          create: (context) {
            final repository = MaintenanceRecommendationRepositoryImpl(
              remoteDataSource: RecommendationRemoteDataSourceImpl(),
            );
            return MaintenanceRecommendationProvider(
              getGeneralRecommendationsUseCase: GetGeneralRecommendations(
                repository,
              ),
              getMotorcycleRecommendationsUseCase: GetMotorcycleRecommendations(
                repository,
              ),
              getAllRecommendationsUseCase: GetAllRecommendations(repository),
              getTechnicalRecommendationsUseCase: GetTechnicalRecommendations(
                repository,
              ),
              getSafetyRecommendationsUseCase: GetSafetyRecommendations(
                repository,
              ),
              getPerformanceRecommendationsUseCase:
                  GetPerformanceRecommendations(repository),
              getRecommendationsByCategoryUseCase: GetRecommendationsByCategory(
                repository,
              ),
              getRecommendationsByPriorityUseCase: GetRecommendationsByPriority(
                repository,
              ),
              getUpcomingRecommendationsUseCase: GetUpcomingRecommendations(
                repository,
              ),
              deleteRecommendationUseCase: DeleteRecommendation(repository),
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
          '/perfil': (context) => PerfilUser(),
          '/maintenance-recommendations': (context) {
            final args =
                ModalRoute.of(context)?.settings.arguments
                    as Map<String, dynamic>?;
            return MaintenanceRecommendationsPage(
              motorcycleId: args?['motorcycleId'] as String?,
              motorcycleName: args?['motorcycleName'] as String?,
            );
          },
          '/register-maintenance': (context) {
            final arguments = ModalRoute.of(context)!.settings.arguments;
            if (arguments is List<Map<String, dynamic>>) {
              return MaintenanceRegisterPage(motos: arguments);
            } else {
              // Fallback por si los argumentos no son correctos
              return MaintenanceRegisterPage(motos: []);
            }
          },
          '/edit-motorcycle': (context) {
            final motorcycle =
                ModalRoute.of(context)!.settings.arguments as MotorcycleModel;
            return EditMotorcyclePage(motorcycle: motorcycle);
          },
          '/test-recommendations': (context) => const TestRecommendationsPage(),
        },
      ),
    );
  }
}
