import '../../domain/entities/maintenance_entity.dart';

/// Modelo de datos para mantenimiento
class MaintenanceModel extends MaintenanceEntity {
  const MaintenanceModel({
    super.id,
    required super.type,
    required super.date,
    required super.cost,
    required super.motorcycleName,
    super.motorcycleId,
    super.description,
    super.notes,
    super.createdAt,
  });

  factory MaintenanceModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceModel(
      id: json['id']?.toString(),
      type: json['type'] ?? json['tipo'] ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : (json['fecha'] != null
                ? DateTime.parse(json['fecha'])
                : DateTime.now()),
      cost: (json['cost'] ?? json['precio'] ?? json['monto'] ?? 0).toDouble(),
      motorcycleName:
          json['motorcycleName'] ??
          json['nombreMoto'] ??
          json['moto'] ??
          'Sin nombre',
      motorcycleId:
          json['motorcycleId']?.toString() ?? json['motocicletaId']?.toString(),
      description: json['description'] ?? json['descripcion'],
      notes: json['notes'] ?? json['notas'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipo': type,
      'fecha': date.toIso8601String(),
      'precio': cost,
      'nombreMoto': motorcycleName,
      'motocicletaId': motorcycleId,
      'descripcion': description,
      'notas': notes,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory MaintenanceModel.fromEntity(MaintenanceEntity entity) {
    return MaintenanceModel(
      id: entity.id,
      type: entity.type,
      date: entity.date,
      cost: entity.cost,
      motorcycleName: entity.motorcycleName,
      motorcycleId: entity.motorcycleId,
      description: entity.description,
      notes: entity.notes,
      createdAt: entity.createdAt,
    );
  }

  MaintenanceEntity toEntity() {
    return MaintenanceEntity(
      id: id,
      type: type,
      date: date,
      cost: cost,
      motorcycleName: motorcycleName,
      motorcycleId: motorcycleId,
      description: description,
      notes: notes,
      createdAt: createdAt,
    );
  }
}
