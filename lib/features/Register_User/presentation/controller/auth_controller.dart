import '../../data/repositories/auth_repository_iml.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/models/user_register_model.dart';

class AuthController {
  final _repository = AuthRepositoryImpl(AuthRemoteDataSource());

  /// Registra un usuario y retorna los datos del backend
  Future<Map<String, dynamic>?> register(
    String email, 
    String password, 
    String nombre, 
    String phone
  ) async {
    final user = UserRegisterModel(
      email: email,
      password: password,
      nombre: nombre,
      phone: phone,
    );

    try {
      final response = await _repository.register(user);
      print('✅ Usuario registrado: ${response['user']}');
      return response; // Retorna { user: {...}, token: "..." }
    } catch (e) {
      print('❌ Error al registrar: $e');
      return null;
    }
  }
}