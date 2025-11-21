import '../../domain/entities/recommendation_entity.dart';
import '../../domain/repositories/recommendation_repository.dart';
import '../datasources/recommendation_remote_data_source.dart';

/// Implementación del repositorio de recomendaciones
class MaintenanceRecommendationRepositoryImpl
    implements MaintenanceRecommendationRepository {
  final RecommendationRemoteDataSource remoteDataSource;

  MaintenanceRecommendationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<MaintenanceRecommendationEntity>>
  getGeneralRecommendations() async {
    try {
      return await remoteDataSource.getGeneralRecommendations();
    } catch (e) {
      throw Exception('Error al obtener recomendaciones: $e');
    }
  }

  @override
  Future<List<MaintenanceRecommendationEntity>> getRecommendationsForMotorcycle(
    String motorcycleId,
  ) async {
    try {
      return await remoteDataSource.getRecommendationsForMotorcycle(
        motorcycleId,
      );
    } catch (e) {
      throw Exception('Error al obtener recomendaciones: $e');
    }
  }
}
