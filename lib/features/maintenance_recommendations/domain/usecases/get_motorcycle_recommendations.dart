import '../entities/recommendation_entity.dart';
import '../repositories/recommendation_repository.dart';

/// Caso de uso para obtener recomendaciones específicas de una moto
class GetMotorcycleRecommendations {
  final MaintenanceRecommendationRepository repository;

  GetMotorcycleRecommendations(this.repository);

  Future<List<MaintenanceRecommendationEntity>> call(
    String motorcycleId,
  ) async {
    return await repository.getRecommendationsForMotorcycle(motorcycleId);
  }
}
