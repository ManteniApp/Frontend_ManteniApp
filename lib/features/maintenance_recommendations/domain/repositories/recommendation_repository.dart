import '../entities/recommendation_entity.dart';

/// Repositorio abstracto para recomendaciones de mantenimiento
abstract class MaintenanceRecommendationRepository {
  /// Obtiene todas las recomendaciones
  Future<List<MaintenanceRecommendationEntity>> getAllRecommendations();

  /// Obtiene recomendaciones técnicas
  Future<List<MaintenanceRecommendationEntity>> getTechnicalRecommendations();

  /// Obtiene todas las recomendaciones generales
  Future<List<MaintenanceRecommendationEntity>> getGeneralRecommendations();

  /// Obtiene recomendaciones de seguridad
  Future<List<MaintenanceRecommendationEntity>> getSafetyRecommendations();

  /// Obtiene recomendaciones de rendimiento
  Future<List<MaintenanceRecommendationEntity>> getPerformanceRecommendations();

  /// Obtiene recomendaciones técnicas por tipo específico
  Future<List<MaintenanceRecommendationEntity>> getTechnicalByType(String type);

  /// Obtiene recomendaciones por categoría
  Future<List<MaintenanceRecommendationEntity>> getRecommendationsByCategory(
    String category,
  );

  /// Obtiene recomendaciones por nivel de prioridad
  Future<List<MaintenanceRecommendationEntity>> getRecommendationsByPriority(
    String priority,
  );

  /// Obtiene próximas recomendaciones
  Future<List<MaintenanceRecommendationEntity>> getUpcomingRecommendations();

  /// Obtiene recomendaciones por tipo de mantenimiento
  Future<List<MaintenanceRecommendationEntity>>
  getRecommendationsByMaintenanceType(String type);

  /// Elimina una recomendación
  Future<bool> deleteRecommendation(String id);

  // Método legacy para mantener compatibilidad
  @Deprecated('Usar getAllRecommendations() o getGeneralRecommendations()')
  Future<List<MaintenanceRecommendationEntity>> getRecommendationsForMotorcycle(
    String motorcycleId,
  );
}
