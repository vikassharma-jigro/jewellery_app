import 'package:dio/dio.dart';
import '../../core/network/api_response.dart';
import '../../core/network/dio_client.dart';
import '../models/stock_dto.dart';

class StockApiService {
  final DioClient _dioClient;

  StockApiService(this._dioClient);

  Future<StockBalanceDto> getGlobalBalance() async {
    try {
      final response = await _dioClient.dio.get('/stock/summary');
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (apiResponse.success && apiResponse.data != null) {
        return StockBalanceDto.fromJson(apiResponse.data!);
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

  Future<List<StockLedgerDto>> getLedger() async {
    try {
      final response = await _dioClient.dio.get('/stock/ledger');
      final apiResponse = ApiResponse<List<dynamic>>.fromJson(
        response.data,
        (json) => json as List<dynamic>,
      );

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data!
            .map((e) => StockLedgerDto.fromJson(e as Map<String, dynamic>))
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
