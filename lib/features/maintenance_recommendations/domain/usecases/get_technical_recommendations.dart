import '../entities/recommendation_entity.dart';
import '../repositories/recommendation_repository.dart';

/// Caso de uso para obtener recomendaciones técnicas
class GetTechnicalRecommendations {
  final MaintenanceRecommendationRepository repository;

  GetTechnicalRecommendations(this.repository);

  /// Ejecuta el caso de uso
  Future<List<MaintenanceRecommendationEntity>> call() async {
    return await repository.getTechnicalRecommendations();
  }
}
