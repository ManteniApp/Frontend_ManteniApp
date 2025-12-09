import '../entities/recommendation_entity.dart';
import '../repositories/recommendation_repository.dart';

/// Caso de uso para obtener recomendaciones generales
class GetGeneralRecommendations {
  final MaintenanceRecommendationRepository repository;

  GetGeneralRecommendations(this.repository);

  Future<List<MaintenanceRecommendationEntity>> call() async {
    return await repository.getGeneralRecommendations();
  }
}
