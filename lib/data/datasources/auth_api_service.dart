import 'package:dio/dio.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/network/api_response.dart';
import '../../core/network/dio_client.dart';
import '../models/user_dto.dart';
import '../../core/storage/auth_storage.dart';

class AuthApiService {
  final DioClient _dioClient;
  final AuthStorage _authStorage;

  AuthApiService(this._dioClient, this._authStorage);

  Future<UserDto> login(String emailOrPhone, String password) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.login,
        data: {'emailOrPhone': emailOrPhone, 'password': password},
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (apiResponse.success && apiResponse.data != null) {
        // Save tokens
        final accessToken = apiResponse.data!['accessToken'];
        if (accessToken != null) {
          await _authStorage.saveToken(accessToken);
        }
        
        final userData = apiResponse.data!['user'] ?? apiResponse.data!;
        return UserDto.fromJson(userData);
      } else {
        throw Exception(apiResponse.message.isNotEmpty 
            ? apiResponse.message 
            : 'Login failed');
      }
    } catch (e) {
      if (e is DioException) {
        final message = e.response?.data['message'] ?? e.message;
        throw Exception(message);
      }
      throw Exception('Network error: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _dioClient.dio.post('/auth/logout');
    } catch (_) {}
    await _authStorage.deleteToken();
  }

  Future<UserDto> fetchProfile() async {
    try {
      final response = await _dioClient.dio.get('/users/profile');
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (apiResponse.success && apiResponse.data != null) {
        return UserDto.fromJson(apiResponse.data!);
      } else {
        throw Exception('Failed to fetch profile');
      }
    } catch (e) {
      throw Exception('Network error');
    }
  }

  Future<UserDto> updateProfile(Map<String, dynamic> updateData, {String? imagePath}) async {
    try {
      dynamic dataToPass = updateData;
      if (imagePath != null) {
        final formData = FormData.fromMap(updateData);
        formData.files.add(
          MapEntry(
            'avatarUrl',
            await MultipartFile.fromFile(imagePath, filename: imagePath.split('/').last),
          ),
        );
        dataToPass = formData;
      }
      
      final response = await _dioClient.dio.put('/users/profile', data: dataToPass);
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (apiResponse.success && apiResponse.data != null) {
        return UserDto.fromJson(apiResponse.data!);
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      throw Exception('Failed to update profile');
    }
  }
}
