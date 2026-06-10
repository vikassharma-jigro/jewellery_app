import 'package:dio/dio.dart';
import '../storage/auth_storage.dart';

class AuthInterceptor extends Interceptor {
  final AuthStorage _authStorage;

  AuthInterceptor(this._authStorage);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _authStorage.getToken();
    
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Handle unauthorized access (e.g., clear token, trigger logout event)
      _authStorage.deleteToken();
      // In a real app, you might want to redirect to login screen here using a global navigator key or stream
    }
    return handler.next(err);
  }
}
