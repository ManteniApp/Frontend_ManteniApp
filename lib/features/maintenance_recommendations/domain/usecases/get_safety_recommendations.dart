import '../entities/recommendation_entity.dart';
import '../repositories/recommendation_repository.dart';

/// Caso de uso para obtener recomendaciones de seguridad
class GetSafetyRecommendations {
  final MaintenanceRecommendationRepository repository;

  GetSafetyRecommendations(this.repository);

  /// Ejecuta el caso de uso
  Future<List<MaintenanceRecommendationEntity>> call() async {
    return await repository.getSafetyRecommendations();
  }
}
