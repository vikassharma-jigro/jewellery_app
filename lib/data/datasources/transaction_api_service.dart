import 'package:dio/dio.dart';
import '../../core/network/api_response.dart';
import '../../core/network/dio_client.dart';
import '../models/transaction_dto.dart';

class TransactionApiService {
  final DioClient _dioClient;

  TransactionApiService(this._dioClient);

  Future<TransactionDto> createTransaction(Map<String, dynamic> data) async {
    try {
      final response = await _dioClient.dio.post('/transactions', data: data);
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (apiResponse.success && apiResponse.data != null) {
        return TransactionDto.fromJson(apiResponse.data!);
      } else {
        throw Exception(apiResponse.message);
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data['message'] ?? e.message);
      }
      throw Exception('Network error: $e');
    }
  }

  Future<List<TransactionDto>> getCustomerTransactions(String customerId) async {
    try {
      final response = await _dioClient.dio.get('/transactions/customers/$customerId');
      final apiResponse = ApiResponse<List<dynamic>>.fromJson(
        response.data,
        (json) => json as List<dynamic>,
      );

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data!
            .map((e) => TransactionDto.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(apiResponse.message);
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data['message'] ?? e.message);
      }
      throw Exception('Network error: $e');
    }
  }
}
