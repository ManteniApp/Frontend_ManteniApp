import 'package:flutter/material.dart';
import '../../domain/entities/recommendation_entity.dart';
import '../../domain/usecases/get_general_recommendations.dart';
import '../../domain/usecases/get_motorcycle_recommendations.dart';

/// Estados posibles del provider
enum RecommendationState { initial, loading, loaded, error }

/// Provider para manejar el estado de las recomendaciones
class MaintenanceRecommendationProvider extends ChangeNotifier {
  final GetGeneralRecommendations getGeneralRecommendationsUseCase;
  final GetMotorcycleRecommendations getMotorcycleRecommendationsUseCase;

  MaintenanceRecommendationProvider({
    required this.getGeneralRecommendationsUseCase,
    required this.getMotorcycleRecommendationsUseCase,
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
