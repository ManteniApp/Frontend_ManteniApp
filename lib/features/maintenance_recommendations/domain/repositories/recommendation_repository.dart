import '../entities/recommendation_entity.dart';

/// Repositorio abstracto para recomendaciones de mantenimiento
abstract class MaintenanceRecommendationRepository {
  /// Obtiene todas las recomendaciones generales
  Future<List<MaintenanceRecommendationEntity>> getGeneralRecommendations();

  /// Obtiene recomendaciones específicas para una motocicleta
  Future<List<MaintenanceRecommendationEntity>> getRecommendationsForMotorcycle(
    String motorcycleId,
  );
}
