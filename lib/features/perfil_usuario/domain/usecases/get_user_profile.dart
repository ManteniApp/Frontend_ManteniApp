import '../entities/user_entity.dart';
import '../repositories/perfil_repository.dart';

class GetUserProfile {
  final PerfilRepository repository;

  GetUserProfile(this.repository);

  Future<UserEntity> call(String userId) {
    return repository.getUserProfile(userId);
  }
}