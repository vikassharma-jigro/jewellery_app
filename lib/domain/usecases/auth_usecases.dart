import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase(this.repository);

  Future<UserEntity> call(String emailOrPhone, String password) async {
    return await repository.login(emailOrPhone, password);
  }
}

class CheckAuthStatusUsecase {
  final AuthRepository repository;

  CheckAuthStatusUsecase(this.repository);

  Future<UserEntity?> call() async {
    return await repository.checkAuthStatus();
  }
}

class LogoutUsecase {
  final AuthRepository repository;

  LogoutUsecase(this.repository);

  Future<void> call() async {
    return await repository.logout();
  }
}

class UpdateProfileUsecase {
  final AuthRepository repository;

  UpdateProfileUsecase(this.repository);

  Future<UserEntity> call(Map<String, dynamic> updateData, {String? imagePath}) async {
    return await repository.updateProfile(updateData, imagePath: imagePath);
  }
}
