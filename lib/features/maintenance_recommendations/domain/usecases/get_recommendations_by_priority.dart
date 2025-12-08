import '../entities/recommendation_entity.dart';
import '../repositories/recommendation_repository.dart';

/// Caso de uso para obtener recomendaciones por prioridad
class GetRecommendationsByPriority {
  final MaintenanceRecommendationRepository repository;

  GetRecommendationsByPriority(this.repository);

  /// Ejecuta el caso de uso
  ///
  /// [priority] - El nivel de prioridad (bajo, medio, alto, crítico)
  Future<List<MaintenanceRecommendationEntity>> call(String priority) async {
    return await repository.getRecommendationsByPriority(priority);
  }
}
