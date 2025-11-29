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

  /// Helper para parsear el costo que puede venir como número o string
  static double _parseCost(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  factory MaintenanceModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceModel(
      id: json['id']?.toString(),
      type: json['type'] ?? json['tipo'] ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : (json['fecha'] != null
                ? DateTime.parse(json['fecha'])
                : DateTime.now()),
      cost: _parseCost(
        json['cost'] ?? json['costo'] ?? json['precio'] ?? json['monto'],
      ),
      motorcycleName:
          json['motorcycleName'] ??
          json['nombreMoto'] ??
          json['moto'] ??
          'Sin nombre',
      motorcycleId:
          json['motorcycleId']?.toString() ?? json['motocicletaId']?.toString()?? json['moto_id']?.toString(),
      description: json['description'] ?? json['descripcion'],
      notes: json['notes'] ?? json['notas'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'tipo': type, // Backend espera 'tipo'
      'fecha': date.toIso8601String(), // Backend espera 'fecha'
      'precio': cost, // Backend espera 'precio'
      'nombreMoto': motorcycleName, // Backend espera 'nombreMoto'
      if (motorcycleId != null)
        'moto_id': int.parse(
          motorcycleId!,
        ), // Backend espera 'moto_id' como int
      if (description != null)
        'descripcion': description, // Backend espera 'descripcion'
      if (notes != null) 'notas': notes, // Backend espera 'notas'
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }

  /// ⚠️ Solo para actualización - Backend solo acepta: descripcion y costo
  Map<String, dynamic> toUpdateJson() {
    return {
      'costo': cost, // ⚠️ Backend espera 'costo' (no 'precio') en PUT
      if (description != null)
        'descripcion': description, // ✅ Descripción (permitido)
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
