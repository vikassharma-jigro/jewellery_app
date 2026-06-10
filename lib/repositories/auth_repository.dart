import 'package:dio/dio.dart';
import '../core/api_service.dart';
import '../core/constants.dart';
import '../core/exceptions.dart';
import '../data/models/user_model.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  Future<UserModel> login(String userId, String password) async {
    try {
      final response = await _apiService.dio.post(
        ApiConstants.login,
        data: {'userId': userId, 'password': password},
      );

      final responseData = response.data['data'] ?? response.data;
      final token = responseData['accessToken'];
      final refreshToken = responseData['refreshToken'];

      if (token != null) {
        await _apiService.secureStorage.write(
          key: 'access_token',
          value: token,
        );
      }
      if (refreshToken != null) {
        await _apiService.secureStorage.write(
          key: 'refresh_token',
          value: refreshToken,
        );
      }

      return UserModel.fromJson(responseData['user'] ?? {});
    } on DioException catch (e) {
      final message = e.response?.data['message'];
      final String errorMessage = message is List ? message.join(', ') : (message?.toString() ?? 'Login failed');
      throw AppException(errorMessage);
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  Future<void> logout() async {
    await _apiService.secureStorage.delete(key: 'access_token');
    await _apiService.secureStorage.delete(key: 'refresh_token');
  }

  Future<bool> isLoggedIn() async {
    final token = await _apiService.secureStorage.read(key: 'access_token');
    return token != null;
  }
}
