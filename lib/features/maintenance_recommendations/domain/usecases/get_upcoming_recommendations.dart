import '../entities/recommendation_entity.dart';
import '../repositories/recommendation_repository.dart';

/// Caso de uso para obtener próximas recomendaciones
class GetUpcomingRecommendations {
  final MaintenanceRecommendationRepository repository;

  GetUpcomingRecommendations(this.repository);

  /// Ejecuta el caso de uso
  Future<List<MaintenanceRecommendationEntity>> call() async {
    return await repository.getUpcomingRecommendations();
  }
}
