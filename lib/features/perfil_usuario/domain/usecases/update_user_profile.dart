import '../entities/user_entity.dart';
import '../repositories/perfil_repository.dart';

class UpdateUserProfile {
  final PerfilRepository repository;

  UpdateUserProfile(this.repository);

  Future<bool> call(UserEntity user, String userId) {
    return repository.updateUserProfile(user);
  }
}