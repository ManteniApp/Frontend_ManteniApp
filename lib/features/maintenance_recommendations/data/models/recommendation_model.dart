import '../../domain/entities/recommendation_entity.dart';

/// Modelo de datos para recomendaciones de mantenimiento
class MaintenanceRecommendationModel extends MaintenanceRecommendationEntity {
  const MaintenanceRecommendationModel({
    required super.id,
    required super.componentName,
    required super.category,
    required super.description,
    super.frequencyKm,
    super.frequencyMonths,
    required super.explanation,
    required super.iconName,
    required super.priority,
    super.warningSignals,
  });

  /// Crea un modelo desde JSON
  factory MaintenanceRecommendationModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceRecommendationModel(
      id: json['id']?.toString() ?? '',
      componentName: json['componentName'] ?? json['nombre'] ?? '',
      category: json['category'] ?? json['categoria'] ?? '',
      description: json['description'] ?? json['descripcion'] ?? '',
      frequencyKm: json['frequencyKm'] ?? json['frecuenciaKm'],
      frequencyMonths: json['frequencyMonths'] ?? json['frecuenciaMeses'],
      explanation: json['explanation'] ?? json['explicacion'] ?? '',
      iconName: json['iconName'] ?? json['icono'] ?? 'build',
      priority: json['priority'] ?? json['prioridad'] ?? 'medio',
      warningSignals: json['warningSignals'] != null
          ? List<String>.from(json['warningSignals'])
          : (json['senalesAdvertencia'] != null
                ? List<String>.from(json['senalesAdvertencia'])
                : null),
    );
  }

  /// Convierte el modelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'componentName': componentName,
      'category': category,
      'description': description,
      'frequencyKm': frequencyKm,
      'frequencyMonths': frequencyMonths,
      'explanation': explanation,
      'iconName': iconName,
      'priority': priority,
      'warningSignals': warningSignals,
    };
  }
}
