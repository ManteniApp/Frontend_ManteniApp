import 'package:equatable/equatable.dart';

/// Entidad que representa una recomendación de mantenimiento
class MaintenanceRecommendationEntity extends Equatable {
  /// ID único de la recomendación
  final String id;

  /// Nombre del componente o servicio
  final String componentName;

  /// Categoría del servicio (aceite, frenos, llantas, etc.)
  final String category;

  /// Descripción del componente
  final String description;

  /// Frecuencia recomendada en kilómetros
  final int? frequencyKm;

  /// Frecuencia recomendada en meses
  final int? frequencyMonths;

  /// Explicación detallada de por qué es importante
  final String explanation;

  /// Icono representativo (nombre del icono de Material Icons)
  final String iconName;

  /// Nivel de prioridad (bajo, medio, alto, crítico)
  final String priority;

  /// Señales de advertencia que indican que necesita atención
  final List<String>? warningSignals;

  const MaintenanceRecommendationEntity({
    required this.id,
    required this.componentName,
    required this.category,
    required this.description,
    this.frequencyKm,
    this.frequencyMonths,
    required this.explanation,
    required this.iconName,
    required this.priority,
    this.warningSignals,
  });

  @override
  List<Object?> get props => [
    id,
    componentName,
    category,
    description,
    frequencyKm,
    frequencyMonths,
    explanation,
    iconName,
    priority,
    warningSignals,
  ];

  /// Retorna el texto de frecuencia formateado
  String get frequencyText {
    final parts = <String>[];
    if (frequencyKm != null) {
      parts.add('$frequencyKm km');
    }
    if (frequencyMonths != null) {
      parts.add('$frequencyMonths meses');
    }
    return parts.isEmpty ? 'Variable' : parts.join(' o ');
  }
}
