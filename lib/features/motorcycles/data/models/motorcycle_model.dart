import '../../domain/entities/motorcycle_entity.dart';

class MotorcycleModel extends MotorcycleEntity {
  const MotorcycleModel({
    super.id,
    required super.brand,
    required super.model,
    required super.imageUrl,
    super.licensePlate, // 👈 Agregado
    required super.year,
    required super.displacement,
    required super.mileage,
    super.createdAt,
    super.updatedAt,
  });

  factory MotorcycleModel.fromJson(Map<String, dynamic> json) {
    // Lógica de fallback para la imagen:
    // 1. Si hay imagen_local, usar con prefijo del backend
    // 2. Si no, usar imagen_url (agregando prefijo si es relativa)
    // 3. Si no hay ninguna, dejar vacío (el UI mostrará placeholder)
    String imageUrl = '';

    final imagenLocal = json['imagen_local'];
    final imagenUrl = json['imagen_url'];
    final imageUrlCamel = json['imageUrl'];

    if (imagenLocal != null && imagenLocal.toString().trim().isNotEmpty) {
      // Usar imagen local con prefijo del backend
      imageUrl = 'http://localhost:3000${imagenLocal}';
      print('🖼️ [Modelo] Usando imagen_local: $imageUrl');
    } else if (imagenUrl != null && imagenUrl.toString().trim().isNotEmpty) {
      // Si imagen_url es relativa (empieza con /), agregar prefijo del backend
      final urlStr = imagenUrl.toString();
      if (urlStr.startsWith('/')) {
        imageUrl = 'http://localhost:3000$urlStr';
        print('🖼️ [Modelo] Usando imagen_url relativa: $imageUrl');
      } else {
        // URL absoluta, usar directamente
        imageUrl = urlStr;
        print('🖼️ [Modelo] Usando imagen_url absoluta: $imageUrl');
      }
    } else if (imageUrlCamel != null &&
        imageUrlCamel.toString().trim().isNotEmpty) {
      // Soporte para imageUrl en camelCase (por si acaso)
      final urlStr = imageUrlCamel.toString();
      if (urlStr.startsWith('/')) {
        imageUrl = 'http://localhost:3000$urlStr';
        print('🖼️ [Modelo] Usando imageUrl camelCase relativa: $imageUrl');
      } else {
        imageUrl = urlStr;
        print('🖼️ [Modelo] Usando imageUrl camelCase absoluta: $imageUrl');
      }
    } else {
      print('⚠️ [Modelo] No hay imagen disponible para moto ID: ${json['id']}');
    }

    return MotorcycleModel(
      id: json['id']?.toString(),
      brand: json['brand'] ?? json['marca'] ?? '', // 👈 Soporte para 'marca'
      model: json['model'] ?? json['modelo'] ?? '', // 👈 Soporte para 'modelo'
      imageUrl: imageUrl,
      licensePlate:
          json['licensePlate'] ?? json['placa'], // 👈 Soporte para 'placa'
      year:
          json['year'] ??
          json['año'] ??
          json['anio'] ??
          0, // 👈 Soporte para 'año' y 'anio'
      displacement:
          json['displacement'] ??
          json['cilindraje'] ??
          0, // 👈 Soporte para 'cilindraje'
      mileage:
          json['mileage'] ??
          json['kilometraje'] ??
          0, // 👈 Soporte para 'kilometraje'
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
      'marca': brand, // 👈 Usar 'marca' en lugar de 'brand'
      'modelo': model, // 👈 Usar 'modelo' en lugar de 'model'
      'placa': licensePlate, // 👈 Usar 'placa'
      'anio': year, // 👈 Usar 'anio' en lugar de 'year'
      'cilindraje': displacement, // 👈 Usar 'cilindraje'
      'kilometraje': mileage, // 👈 Usar 'kilometraje' en lugar de 'mileage'
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory MotorcycleModel.fromEntity(MotorcycleEntity entity) {
    return MotorcycleModel(
      id: entity.id,
      brand: entity.brand,
      model: entity.model,
      imageUrl: entity.imageUrl,
      licensePlate: entity.licensePlate, // 👈 Agregado
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
      imageUrl: imageUrl,
      licensePlate: licensePlate, // 👈 Agregado
      year: year,
      displacement: displacement,
      mileage: mileage,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
