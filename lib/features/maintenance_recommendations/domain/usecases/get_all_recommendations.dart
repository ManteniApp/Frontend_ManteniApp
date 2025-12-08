import '../entities/recommendation_entity.dart';
import '../repositories/recommendation_repository.dart';

/// Caso de uso para obtener todas las recomendaciones
class GetAllRecommendations {
  final MaintenanceRecommendationRepository repository;

  GetAllRecommendations(this.repository);

  /// Ejecuta el caso de uso
  Future<List<MaintenanceRecommendationEntity>> call() async {
    return await repository.getAllRecommendations();
  }
}
