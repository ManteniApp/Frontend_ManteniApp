import '../../domain/entities/motorcycle_entity.dart';

class MotorcycleModel extends MotorcycleEntity {
  const MotorcycleModel({
    super.id,
    required super.brand,
    required super.model,
    required super.year,
    required super.displacement,
    required super.mileage,
    super.createdAt,
    super.updatedAt,
  });

  factory MotorcycleModel.fromJson(Map<String, dynamic> json) {
    return MotorcycleModel(
      id: json['id']?.toString(),
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      year: json['year'] ?? 0,
      displacement: json['displacement'] ?? 0,
      mileage: json['mileage'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brand,
      'model': model,
      'year': year,
      'displacement': displacement,
      'mileage': mileage,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory MotorcycleModel.fromEntity(MotorcycleEntity entity) {
    return MotorcycleModel(
      id: entity.id,
      brand: entity.brand,
      model: entity.model,
      year: entity.year,
      displacement: entity.displacement,
      mileage: entity.mileage,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  MotorcycleEntity toEntity() {
    return MotorcycleEntity(
      id: id,
      brand: brand,
      model: model,
      year: year,
      displacement: displacement,
      mileage: mileage,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
