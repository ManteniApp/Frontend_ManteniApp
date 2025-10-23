class MotorcycleEntity {
  final String? id;
  final String brand;
  final String model;
  final String? licensePlate; // 👈 Placa (agregado)
  final int year;
  final int displacement; // Cilindraje
  final int mileage;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MotorcycleEntity({
    this.id,
    required this.brand,
    required this.model,
    this.licensePlate, // 👈 Agregado
    required this.year,
    required this.displacement,
    required this.mileage,
    this.createdAt,
    this.updatedAt,
  });

  MotorcycleEntity copyWith({
    String? id,
    String? brand,
    String? model,
    String? licensePlate, // 👈 Agregado
    int? year,
    int? displacement,
    int? mileage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MotorcycleEntity(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      licensePlate: licensePlate ?? this.licensePlate, // 👈 Agregado
      year: year ?? this.year,
      displacement: displacement ?? this.displacement,
      mileage: mileage ?? this.mileage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'MotorcycleEntity(id: $id, brand: $brand, model: $model, year: $year, displacement: $displacement)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MotorcycleEntity &&
        other.id == id &&
        other.brand == brand &&
        other.model == model;
  }

  @override
  int get hashCode => id.hashCode ^ brand.hashCode ^ model.hashCode;
}
