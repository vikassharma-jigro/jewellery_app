import 'package:dio/dio.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/network/api_response.dart';
import '../../core/network/dio_client.dart';
import '../models/customer_dto.dart';

class CustomerApiService {
  final DioClient _dioClient;

  CustomerApiService(this._dioClient);

  Future<List<CustomerDto>> getCustomers() async {
    try {
      final response = await _dioClient.dio.get(ApiEndpoints.customers);
      
      final apiResponse = ApiResponse<List<dynamic>>.fromJson(
        response.data,
        (json) => json as List<dynamic>,
      );

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data!
            .map((e) => CustomerDto.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(apiResponse.message.isNotEmpty 
            ? apiResponse.message 
            : 'Failed to fetch customers');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<CustomerDto> createCustomer(CustomerDto customerDto) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.customers,
        data: customerDto.toJson(),
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (apiResponse.success && apiResponse.data != null) {
        return CustomerDto.fromJson(apiResponse.data!);
      } else {
        throw Exception(apiResponse.message.isNotEmpty 
            ? apiResponse.message 
            : 'Failed to create customer');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
