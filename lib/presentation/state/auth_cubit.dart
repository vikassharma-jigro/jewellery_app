import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/auth_usecases.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUsecase _loginUsecase;
  final CheckAuthStatusUsecase _checkAuthStatusUsecase;
  final LogoutUsecase _logoutUsecase;
  final UpdateProfileUsecase _updateProfileUsecase;

  AuthCubit(
    this._loginUsecase,
    this._checkAuthStatusUsecase,
    this._logoutUsecase,
    this._updateProfileUsecase,
  ) : super(AuthInitial());

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    final user = await _checkAuthStatusUsecase.call();
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> login(String emailOrPhone, String password) async {
    emit(AuthLoading());
    try {
      final user = await _loginUsecase.call(emailOrPhone, password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> logout() async {
    await _logoutUsecase.call();
    emit(AuthUnauthenticated());
  }

  Future<void> updateProfile(Map<String, dynamic> updateData, {String? imagePath}) async {
    try {
      final user = await _updateProfileUsecase.call(updateData, imagePath: imagePath);
      emit(AuthAuthenticated(user));
    } catch (e) {
      // Re-emit current state with error maybe, or just throw error to UI
      throw Exception('Failed to update profile');
    }
  }
}
