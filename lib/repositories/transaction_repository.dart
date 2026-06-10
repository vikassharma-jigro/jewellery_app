import 'package:dio/dio.dart';
import '../core/api_service.dart';
import '../core/constants.dart';
import '../core/exceptions.dart';
import '../data/models/transaction_model.dart';

class TransactionRepository {
  final ApiService _apiService;

  TransactionRepository(this._apiService);

  Future<TransactionModel> createTransaction({
    required String customerId,
    required TransactionType type,
    required MetalType metalType,
    double? weight,
    double? amount,
    String? remark,
  }) async {
    try {
      final response = await _apiService.dio.post(
        ApiConstants.transactions,
        data: {
          'customerId': customerId,
          'type': type.name.toUpperCase().replaceAll('IN', '_IN').replaceAll('OUT', '_OUT'), // Simplistic conversion to enum string
          'metalType': metalType.name.toUpperCase(),
          if (weight != null) 'weight': weight,
          if (amount != null) 'amount': amount,
          if (remark != null) 'remark': remark,
        },
      );
      final responseData = (response.data is Map<String, dynamic> && (response.data as Map<String, dynamic>).containsKey('data')) ? response.data['data'] : response.data;
      return TransactionModel.fromJson(responseData);
    } on DioException catch (e) {
      throw AppException(e.response?.data['message'] ?? 'Failed to create transaction');
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    try {
      final response = await _apiService.dio.get(ApiConstants.transactions);
      final List data = (response.data is Map<String, dynamic> && (response.data as Map<String, dynamic>).containsKey('data')) ? response.data['data'] : response.data;
      return data.map((json) => TransactionModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw AppException(e.response?.data['message'] ?? 'Failed to fetch all transactions');
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  Future<List<TransactionModel>> getTransactionsByCustomer(String customerId) async {
    try {
      final response = await _apiService.dio.get(ApiConstants.transactionsByCustomer(customerId));
      final List data = (response.data is Map<String, dynamic> && (response.data as Map<String, dynamic>).containsKey('data')) ? response.data['data'] : response.data;
      return data.map((json) => TransactionModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw AppException(e.response?.data['message'] ?? 'Failed to fetch transactions');
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
