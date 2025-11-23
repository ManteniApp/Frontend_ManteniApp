import '../../domain/entities/recommendation_entity.dart';
import '../../domain/repositories/recommendation_repository.dart';
import '../datasources/recommendation_remote_data_source.dart';
import '../datasources/recommendation_mock_data_source.dart';

/// ⚠️ CONFIGURACIÓN: Cambiar a false cuando el backend esté listo
const bool USE_MOCK_DATA = true;

/// Implementación del repositorio de recomendaciones
class MaintenanceRecommendationRepositoryImpl
    implements MaintenanceRecommendationRepository {
  final RecommendationRemoteDataSource? remoteDataSource;
  final RecommendationMockDataSource? mockDataSource;

  MaintenanceRecommendationRepositoryImpl({
    this.remoteDataSource,
    this.mockDataSource,
  }) : assert(
         remoteDataSource != null || mockDataSource != null,
         'Debe proporcionar al menos un data source',
       );

  @override
  Future<List<MaintenanceRecommendationEntity>>
  getGeneralRecommendations() async {
    try {
      if (USE_MOCK_DATA) {
        print('🎭 [Repository] Usando datos MOCK');
        final mock = mockDataSource ?? RecommendationMockDataSource();
        return await mock.getGeneralRecommendations();
      } else {
        print('📡 [Repository] Usando datos REALES del backend');
        return await remoteDataSource!.getGeneralRecommendations();
      }
    } catch (e) {
      throw Exception('Error al obtener recomendaciones: $e');
    }
  }

  @override
  Future<List<MaintenanceRecommendationEntity>> getRecommendationsForMotorcycle(
    String motorcycleId,
  ) async {
    try {
      if (USE_MOCK_DATA) {
        print('🎭 [Repository] Usando datos MOCK para moto $motorcycleId');
        final mock = mockDataSource ?? RecommendationMockDataSource();
        return await mock.getRecommendationsForMotorcycle(motorcycleId);
      } else {
        print('📡 [Repository] Usando datos REALES del backend');
        return await remoteDataSource!.getRecommendationsForMotorcycle(
          motorcycleId,
        );
      }
    } catch (e) {
      throw Exception('Error al obtener recomendaciones: $e');
    }
  }
}
