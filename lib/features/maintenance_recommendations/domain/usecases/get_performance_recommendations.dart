import '../entities/recommendation_entity.dart';
import '../repositories/recommendation_repository.dart';

/// Caso de uso para obtener recomendaciones de rendimiento
class GetPerformanceRecommendations {
  final MaintenanceRecommendationRepository repository;

  GetPerformanceRecommendations(this.repository);

  /// Ejecuta el caso de uso
  Future<List<MaintenanceRecommendationEntity>> call() async {
    return await repository.getPerformanceRecommendations();
  }
}
