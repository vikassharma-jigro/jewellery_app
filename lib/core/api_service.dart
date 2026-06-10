import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'constants.dart';

class ApiService {
  late final Dio dio;
  final FlutterSecureStorage secureStorage;

  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal() : secureStorage = const FlutterSecureStorage() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await secureStorage.read(key: 'access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            final refreshToken = await secureStorage.read(key: 'refresh_token');
            if (refreshToken != null) {
              try {
                final refreshDio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
                refreshDio.options.headers['Authorization'] = 'Bearer $refreshToken';
                
                final response = await refreshDio.post(ApiConstants.refresh);
                
                if (response.statusCode == 200 || response.statusCode == 201) {
                  final newAccessToken = response.data['accessToken'];
                  final newRefreshToken = response.data['refreshToken'];
                  
                  if (newAccessToken != null) {
                    await secureStorage.write(key: 'access_token', value: newAccessToken);
                  }
                  if (newRefreshToken != null) {
                    await secureStorage.write(key: 'refresh_token', value: newRefreshToken);
                  }
                  
                  e.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
                  
                  final retryResponse = await dio.fetch(e.requestOptions);
                  return handler.resolve(retryResponse);
                }
              } catch (refreshError) {
                await secureStorage.delete(key: 'access_token');
                await secureStorage.delete(key: 'refresh_token');
              }
            }
          }
          return handler.next(e);
        },
      ),
    );

    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
    ));
  }
}
