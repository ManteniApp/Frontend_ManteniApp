import '../../data/models/user_register_model.dart';

abstract class AuthRepository {
  Future<Map<String, dynamic>> register(UserRegisterModel user); // ← Cambio de bool a Map
}