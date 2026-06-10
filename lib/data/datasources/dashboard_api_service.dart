import 'package:dio/dio.dart';
import '../../core/network/api_response.dart';
import '../../core/network/dio_client.dart';
import '../models/dashboard_dto.dart';

class DashboardApiService {
  final DioClient _dioClient;

  DashboardApiService(this._dioClient);

  Future<DashboardDto> getDashboardSummary() async {
    try {
      final response = await _dioClient.dio.get('/dashboard/summary');
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (apiResponse.success && apiResponse.data != null) {
        return DashboardDto.fromJson(apiResponse.data!);
      } else {
        throw Exception(apiResponse.message.isNotEmpty 
            ? apiResponse.message 
            : 'Failed to fetch dashboard summary');
      }
    } catch (e) {
      if (e is DioException) {
        final message = e.response?.data['message'] ?? e.message;
        throw Exception(message);
      }
      throw Exception('Network error: $e');
    }
  }
}
