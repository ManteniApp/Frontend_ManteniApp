import '../repositories/recommendation_repository.dart';

/// Caso de uso para eliminar una recomendación
class DeleteRecommendation {
  final MaintenanceRecommendationRepository repository;

  DeleteRecommendation(this.repository);

  /// Ejecuta el caso de uso
  ///
  /// [id] - El ID de la recomendación a eliminar
  /// Retorna true si se eliminó exitosamente, false en caso contrario
  Future<bool> call(String id) async {
    return await repository.deleteRecommendation(id);
  }
}
