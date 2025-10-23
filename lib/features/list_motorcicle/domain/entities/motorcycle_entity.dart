class MotorcycleEntity {
  final String id;
  final String name;
  final String imageUrl;
  final String brand;
  final String model;

  MotorcycleEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.brand,
    required this.model,
  });

  // Getter que combina marca y modelo para mostrar el nombre completo
  String get fullName => '$brand $model';
}
