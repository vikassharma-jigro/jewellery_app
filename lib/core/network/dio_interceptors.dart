import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jewellary_stock/screens/login_screen.dart';
import '../storage/auth_storage.dart';

class AuthInterceptor extends Interceptor {
  final AuthStorage _authStorage;
  final BuildContext context;

  AuthInterceptor(this._authStorage, this.context);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _authStorage.getToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
      _authStorage.deleteToken();
      // In a real app, you might want to redirect to login screen here using a global navigator key or stream
    }
    return handler.next(err);
  }
}
