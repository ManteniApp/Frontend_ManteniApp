import '../repositories/perfil_repository.dart';

class UpdateBasicProfile {
  final PerfilRepository repository;

  UpdateBasicProfile(this.repository);

  Future<bool> call(String userId, String name, String phone) {
    return repository.updateBasicProfile(userId, name, phone);
  }
}