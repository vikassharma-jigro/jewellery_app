import 'package:dio/dio.dart';
import '../core/utils/api_service.dart';
import '../core/utils/constants.dart';
import '../core/utils/exceptions.dart';
import '../data/models/customer_model.dart';

class CustomerRepository {
  final ApiService _apiService;

  CustomerRepository(this._apiService);

  Future<CustomerModel> createCustomer({
    required String name,
    String? mobile,
    String? address,
    String? aadhaar,
    String? gst,
    double? goldBalance,
    String? goldBalanceType,
    double? jewelleryBalance,
    String? jewelleryBalanceType,
    double? paymentDue,
    String? paymentDueType,
    String? currency,
  }) async {
    try {
      final response = await _apiService.dio.post(
        ApiConstants.customers,
        data: {
          'name': name,
          'mobile': ?mobile,
          'address': ?address,
          'aadhaar': ?aadhaar,
          'gst': ?gst,
          'goldBalance': ?goldBalance,
          'goldBalanceType': ?goldBalanceType,
          'jewelleryBalance': ?jewelleryBalance,
          'jewelleryBalanceType': ?jewelleryBalanceType,
          'paymentDue': ?paymentDue,
          'paymentDueType': ?paymentDueType,
          'currency': ?currency,
        },
      );
      final responseData =
          (response.data is Map<String, dynamic> &&
              (response.data as Map<String, dynamic>).containsKey('data'))
          ? response.data['data']
          : response.data;
      return CustomerModel.fromJson(responseData);
    } on DioException catch (e) {
      final message = e.response?.data['message'];
      final String errorMessage = message is List
          ? message.join(', ')
          : (message?.toString() ?? 'Failed to create customer');
      throw AppException(errorMessage);
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  Future<List<CustomerModel>> getAllCustomers() async {
    try {
      final response = await _apiService.dio.get(ApiConstants.customers);
      final List data =
          (response.data is Map<String, dynamic> &&
              (response.data as Map<String, dynamic>).containsKey('data'))
          ? response.data['data']
          : response.data;
      return data.map((json) => CustomerModel.fromJson(json)).toList();
    } on DioException catch (e) {
      final message = e.response?.data['message'];
      final String errorMessage = message is List
          ? message.join(', ')
          : (message?.toString() ?? 'Failed to fetch customers');
      throw AppException(errorMessage);
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  Future<CustomerModel> getCustomerById(String id) async {
    try {
      final response = await _apiService.dio.get(
        '${ApiConstants.customers}/$id',
      );
      final responseData =
          (response.data is Map<String, dynamic> &&
              (response.data as Map<String, dynamic>).containsKey('data'))
          ? response.data['data']
          : response.data;
      return CustomerModel.fromJson(responseData);
    } on DioException catch (e) {
      final message = e.response?.data['message'];
      final String errorMessage = message is List
          ? message.join(', ')
          : (message?.toString() ?? 'Failed to fetch customer');
      throw AppException(errorMessage);
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  Future<CustomerModel> updateCustomer({
    required String id,
    String? name,
    String? mobile,
    String? address,
    String? aadhaar,
    String? gst,
    String? amount,
  }) async {
    try {
      final response = await _apiService.dio.put(
        '${ApiConstants.customers}/$id',
        data: {
          'name': ?name,
          'mobile': ?mobile,
          'address': ?address,
          'aadhaar': ?aadhaar,
          'gst': ?gst,
          'amount': ?amount,
        },
      );
      final responseData =
          (response.data is Map<String, dynamic> &&
              (response.data as Map<String, dynamic>).containsKey('data'))
          ? response.data['data']
          : response.data;
      return CustomerModel.fromJson(responseData);
    } on DioException catch (e) {
      final message = e.response?.data['message'];
      final String errorMessage = message is List
          ? message.join(', ')
          : (message?.toString() ?? 'Failed to update customer');
      throw AppException(errorMessage);
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  Future<void> deleteCustomer(String id) async {
    try {
      await _apiService.dio.delete('${ApiConstants.customers}/$id');
    } on DioException catch (e) {
      final message = e.response?.data['message'];
      final String errorMessage = message is List
          ? message.join(', ')
          : (message?.toString() ?? 'Failed to delete customer');
      throw AppException(errorMessage);
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
