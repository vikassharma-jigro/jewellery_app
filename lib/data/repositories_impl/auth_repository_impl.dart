import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_api_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _apiService;

  AuthRepositoryImpl(this._apiService);

  @override
  Future<UserEntity> login(String emailOrPhone, String password) async {
    try {
      final dto = await _apiService.login(emailOrPhone, password);
      return dto.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    await _apiService.logout();
  }

  @override
  Future<UserEntity?> checkAuthStatus() async {
    try {
      final dto = await _apiService.fetchProfile();
      return dto.toEntity();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UserEntity> updateProfile(Map<String, dynamic> updateData, {String? imagePath}) async {
    try {
      final dto = await _apiService.updateProfile(updateData, imagePath: imagePath);
      return dto.toEntity();
    } catch (e) {
      rethrow;
    }
  }
}
