import 'package:flutter/material.dart';
import '../../domain/entities/recommendation_entity.dart';
import '../../domain/usecases/get_general_recommendations.dart';
import '../../domain/usecases/get_motorcycle_recommendations.dart';
import '../../domain/usecases/get_all_recommendations.dart';
import '../../domain/usecases/get_technical_recommendations.dart';
import '../../domain/usecases/get_safety_recommendations.dart';
import '../../domain/usecases/get_performance_recommendations.dart';
import '../../domain/usecases/get_recommendations_by_category.dart';
import '../../domain/usecases/get_recommendations_by_priority.dart';
import '../../domain/usecases/get_upcoming_recommendations.dart';
import '../../domain/usecases/delete_recommendation.dart';

/// Estados posibles del provider
enum RecommendationState { initial, loading, loaded, error }

/// Provider para manejar el estado de las recomendaciones
class MaintenanceRecommendationProvider extends ChangeNotifier {
  final GetGeneralRecommendations getGeneralRecommendationsUseCase;
  final GetMotorcycleRecommendations getMotorcycleRecommendationsUseCase;
  final GetAllRecommendations getAllRecommendationsUseCase;
  final GetTechnicalRecommendations getTechnicalRecommendationsUseCase;
  final GetSafetyRecommendations getSafetyRecommendationsUseCase;
  final GetPerformanceRecommendations getPerformanceRecommendationsUseCase;
  final GetRecommendationsByCategory getRecommendationsByCategoryUseCase;
  final GetRecommendationsByPriority getRecommendationsByPriorityUseCase;
  final GetUpcomingRecommendations getUpcomingRecommendationsUseCase;
  final DeleteRecommendation deleteRecommendationUseCase;

  MaintenanceRecommendationProvider({
    required this.getGeneralRecommendationsUseCase,
    required this.getMotorcycleRecommendationsUseCase,
    required this.getAllRecommendationsUseCase,
    required this.getTechnicalRecommendationsUseCase,
    required this.getSafetyRecommendationsUseCase,
    required this.getPerformanceRecommendationsUseCase,
    required this.getRecommendationsByCategoryUseCase,
    required this.getRecommendationsByPriorityUseCase,
    required this.getUpcomingRecommendationsUseCase,
    required this.deleteRecommendationUseCase,
  });

  RecommendationState _state = RecommendationState.initial;
  List<MaintenanceRecommendationEntity> _recommendations = [];
  String? _errorMessage;
  String? _selectedCategory;

  RecommendationState get state => _state;
  List<MaintenanceRecommendationEntity> get recommendations => _recommendations;
  String? get errorMessage => _errorMessage;
  String? get selectedCategory => _selectedCategory;

  /// Obtiene recomendaciones filtradas por categoría
  List<MaintenanceRecommendationEntity> get filteredRecommendations {
    if (_selectedCategory == null || _selectedCategory == 'Todas') {
      return _recommendations;
    }
    return _recommendations
        .where((r) => r.category == _selectedCategory)
        .toList();
  }

  /// Obtiene todas las categorías únicas
  List<String> get categories {
    final cats = _recommendations.map((r) => r.category).toSet().toList();
    cats.sort();
    return ['Todas', ...cats];
  }

  /// Cambia el filtro de categoría
  void setCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  /// Carga recomendaciones generales
  Future<void> loadGeneralRecommendations() async {
    _state = RecommendationState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _recommendations = await getGeneralRecommendationsUseCase.call();
      _state = RecommendationState.loaded;
    } catch (e) {
      _state = RecommendationState.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  /// Carga todas las recomendaciones
  Future<void> loadAllRecommendations() async {
    _state = RecommendationState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _recommendations = await getAllRecommendationsUseCase.call();
      _state = RecommendationState.loaded;
    } catch (e) {
      _state = RecommendationState.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  /// Carga recomendaciones técnicas
  Future<void> loadTechnicalRecommendations() async {
    _state = RecommendationState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _recommendations = await getTechnicalRecommendationsUseCase.call();
      _state = RecommendationState.loaded;
    } catch (e) {
      _state = RecommendationState.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  /// Carga recomendaciones de seguridad
  Future<void> loadSafetyRecommendations() async {
    _state = RecommendationState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _recommendations = await getSafetyRecommendationsUseCase.call();
      _state = RecommendationState.loaded;
    } catch (e) {
      _state = RecommendationState.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  /// Carga recomendaciones de rendimiento
  Future<void> loadPerformanceRecommendations() async {
    _state = RecommendationState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _recommendations = await getPerformanceRecommendationsUseCase.call();
      _state = RecommendationState.loaded;
    } catch (e) {
      _state = RecommendationState.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  /// Carga recomendaciones por categoría
  Future<void> loadRecommendationsByCategory(String category) async {
    _state = RecommendationState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _recommendations = await getRecommendationsByCategoryUseCase.call(
        category,
      );
      _state = RecommendationState.loaded;
    } catch (e) {
      _state = RecommendationState.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  /// Carga recomendaciones por prioridad
  Future<void> loadRecommendationsByPriority(String priority) async {
    _state = RecommendationState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _recommendations = await getRecommendationsByPriorityUseCase.call(
        priority,
      );
      _state = RecommendationState.loaded;
    } catch (e) {
      _state = RecommendationState.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  /// Carga próximas recomendaciones
  Future<void> loadUpcomingRecommendations() async {
    _state = RecommendationState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _recommendations = await getUpcomingRecommendationsUseCase.call();
      _state = RecommendationState.loaded;
    } catch (e) {
      _state = RecommendationState.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  /// Elimina una recomendación
  Future<bool> deleteRecommendation(String id) async {
    try {
      final result = await deleteRecommendationUseCase.call(id);
      if (result) {
        // Remover de la lista local
        _recommendations.removeWhere((r) => r.id == id);
        notifyListeners();
      }
      return result;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Carga recomendaciones específicas para una motocicleta
  Future<void> loadMotorcycleRecommendations(String motorcycleId) async {
    _state = RecommendationState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _recommendations = await getMotorcycleRecommendationsUseCase.call(
        motorcycleId,
      );
      _state = RecommendationState.loaded;
    } catch (e) {
      _state = RecommendationState.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  /// Limpia el estado
  void clear() {
    _state = RecommendationState.initial;
    _recommendations = [];
    _errorMessage = null;
    _selectedCategory = null;
    notifyListeners();
  }
}
