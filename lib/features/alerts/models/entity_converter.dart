class EntityConverter {
  // Convertir cualquier MotorcycleEntity al tipo correcto
  static dynamic convertMotorcycle(dynamic motorcycle) {
    // Si ya es del tipo correcto, retornarlo directamente
    if (motorcycle.toString().contains('MotorcycleEntity')) {
      return motorcycle;
    }
    
    // Si es un Map, crear una entidad básica
    if (motorcycle is Map) {
      return _createBasicMotorcycleEntity(Map<String, dynamic>.from(motorcycle));
    }
    
    // Para otros casos, usar reflexión básica
    return _createMotorcycleFromDynamic(motorcycle);
  }
  
  static dynamic _createBasicMotorcycleEntity(Map<String, dynamic> map) {
    return {
      'id': map['id']?.toString(),
      'brand': map['brand'] ?? map['marca'] ?? '',
      'model': map['model'] ?? map['modelo'] ?? '',
      'licensePlate': map['licensePlate'] ?? map['placa'] ?? '',
      'year': map['year'] ?? map['año'] ?? 0,
      'mileage': map['mileage'] ?? map['kilometraje'] ?? 0,
    };
  }
  
  static dynamic _createMotorcycleFromDynamic(dynamic moto) {
    try {
      // Usar reflection básica para acceder a las propiedades
      return {
        'id': _getProperty(moto, 'id')?.toString(),
        'brand': _getProperty(moto, 'brand') ?? _getProperty(moto, 'marca') ?? '',
        'model': _getProperty(moto, 'model') ?? _getProperty(moto, 'modelo') ?? '',
        'licensePlate': _getProperty(moto, 'licensePlate') ?? _getProperty(moto, 'placa') ?? '',
        'year': _getProperty(moto, 'year') ?? _getProperty(moto, 'año') ?? 0,
        'mileage': _getProperty(moto, 'mileage') ?? _getProperty(moto, 'kilometraje') ?? 0,
      };
    } catch (e) {
      print('❌ Error convirtiendo moto: $e');
      return null;
    }
  }
  
  static dynamic _getProperty(dynamic obj, String property) {
    try {
      if (obj is Map) {
        return obj[property];
      }
      // Intentar acceder via reflection
      return _getPropertyViaReflection(obj, property);
    } catch (e) {
      return null;
    }
  }
  
  static dynamic _getPropertyViaReflection(dynamic obj, String property) {
    try {
      // Método simple para acceder a propiedades
      if (property == 'id') return obj.id;
      if (property == 'brand') return obj.brand;
      if (property == 'model') return obj.model;
      if (property == 'licensePlate') return obj.licensePlate;
      if (property == 'year') return obj.year;
      if (property == 'mileage') return obj.mileage;
      if (property == 'marca') return obj.brand ?? obj.marca;
      if (property == 'modelo') return obj.model ?? obj.modelo;
      if (property == 'placa') return obj.licensePlate ?? obj.placa;
      if (property == 'año') return obj.year ?? obj.ano;
      if (property == 'kilometraje') return obj.mileage ?? obj.kilometraje;
      return null;
    } catch (e) {
      return null;
    }
  }
}