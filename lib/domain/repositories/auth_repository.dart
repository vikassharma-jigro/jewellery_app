import '../../domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String emailOrPhone, String password);
  Future<void> logout();
  Future<UserEntity?> checkAuthStatus();
  Future<UserEntity> updateProfile(Map<String, dynamic> updateData, {String? imagePath});
}
