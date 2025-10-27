import '../../domain/entities/user_entity.dart';

// En user_model.dart
class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    super.imageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    print('🔄 Parseando JSON del usuario: $json');
    
    // ✅ Mapeo de campos según tu backend
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['nombre'] ?? json['name'] ?? 'Sin nombre',
      email: json['email'] ?? 'Sin email',
      phone: json['telefono'] ?? json['phone'] ?? 'Sin teléfono',
      imageUrl: json['imageUrl'] ?? json['avatar'] ?? json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() => {
        'nombre': name,
        'telefono': phone,  
        'email': email,
        'id': id,
      };
}