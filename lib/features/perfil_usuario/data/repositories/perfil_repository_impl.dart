import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/perfil_repository.dart';
import '../datasources/perfil_remote_datasource.dart';
import '../models/user_model.dart';

class PerfilRepositoryImpl implements PerfilRepository {
  final PerfilRemoteDataSource remoteDataSource;

  PerfilRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> getUserProfile(String userId) async {
    final userModel = await remoteDataSource.getUserProfile(userId);
    return userModel;
  }

  @override
  Future<bool> updateUserProfile(UserEntity user) async {
    final model = UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      imageUrl: user.imageUrl,
    );
    return await remoteDataSource.updateUserProfile(model);
  }

  @override
  Future<bool> updateBasicProfile(String userId, String name, String phone) async {
    return await remoteDataSource.updateBasicProfile(userId, name, phone);
  }
}