import '../entities/user_entity.dart';

abstract class PerfilRepository {
  Future<UserEntity> getUserProfile(String userId);
  Future<bool> updateUserProfile(UserEntity user);
  Future<bool> updateBasicProfile(String userId, String name, String phone);
}