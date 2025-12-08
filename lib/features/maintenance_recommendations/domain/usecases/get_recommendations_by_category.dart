import '../entities/recommendation_entity.dart';
import '../repositories/recommendation_repository.dart';

/// Caso de uso para obtener recomendaciones por categoría
class GetRecommendationsByCategory {
  final MaintenanceRecommendationRepository repository;

  GetRecommendationsByCategory(this.repository);

  /// Ejecuta el caso de uso
  ///
  /// [category] - La categoría para filtrar las recomendaciones
  Future<List<MaintenanceRecommendationEntity>> call(String category) async {
    return await repository.getRecommendationsByCategory(category);
  }
}
