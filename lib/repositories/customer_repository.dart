import 'package:dio/dio.dart';
import '../core/api_service.dart';
import '../core/constants.dart';
import '../core/exceptions.dart';
import '../data/models/customer_model.dart';

class CustomerRepository {
  final ApiService _apiService;

  CustomerRepository(this._apiService);

  Future<CustomerModel> createCustomer({
    required String name,
    required String mobile,
    required String address,
    String? aadhaar,
    String? gst,
    double? goldBalance,
    double? silverBalance,
    double? paymentDue,
  }) async {
    try {
      final response = await _apiService.dio.post(
        ApiConstants.customers,
        data: {
          'name': name,
          'mobile': mobile,
          'address': address,
          if (aadhaar != null) 'aadhaar': aadhaar,
          if (gst != null) 'gst': gst,
          if (goldBalance != null) 'goldBalance': goldBalance,
          if (silverBalance != null) 'silverBalance': silverBalance,
          if (paymentDue != null) 'paymentDue': paymentDue,
        },
      );
      final responseData = (response.data is Map<String, dynamic> && (response.data as Map<String, dynamic>).containsKey('data')) ? response.data['data'] : response.data;
      return CustomerModel.fromJson(responseData);
    } on DioException catch (e) {
      throw AppException(e.response?.data['message'] ?? 'Failed to create customer');
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  Future<List<CustomerModel>> getAllCustomers() async {
    try {
      final response = await _apiService.dio.get(ApiConstants.customers);
      final List data = (response.data is Map<String, dynamic> && (response.data as Map<String, dynamic>).containsKey('data')) ? response.data['data'] : response.data;
      return data.map((json) => CustomerModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw AppException(e.response?.data['message'] ?? 'Failed to fetch customers');
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  Future<CustomerModel> getCustomerById(String id) async {
    try {
      final response = await _apiService.dio.get('${ApiConstants.customers}/$id');
      final responseData = (response.data is Map<String, dynamic> && (response.data as Map<String, dynamic>).containsKey('data')) ? response.data['data'] : response.data;
      return CustomerModel.fromJson(responseData);
    } on DioException catch (e) {
      throw AppException(e.response?.data['message'] ?? 'Failed to fetch customer');
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
  }) async {
    try {
      final response = await _apiService.dio.patch(
        '${ApiConstants.customers}/$id',
        data: {
          if (name != null) 'name': name,
          if (mobile != null) 'mobile': mobile,
          if (address != null) 'address': address,
          if (aadhaar != null) 'aadhaar': aadhaar,
          if (gst != null) 'gst': gst,
        },
      );
      final responseData = (response.data is Map<String, dynamic> && (response.data as Map<String, dynamic>).containsKey('data')) ? response.data['data'] : response.data;
      return CustomerModel.fromJson(responseData);
    } on DioException catch (e) {
      throw AppException(e.response?.data['message'] ?? 'Failed to update customer');
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  Future<void> deleteCustomer(String id) async {
    try {
      await _apiService.dio.delete('${ApiConstants.customers}/$id');
    } on DioException catch (e) {
      throw AppException(e.response?.data['message'] ?? 'Failed to delete customer');
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
