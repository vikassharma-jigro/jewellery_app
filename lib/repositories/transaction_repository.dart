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
    double? grossWeight,
    double? stoneWeight,
    double? wastagePercent,
    double? goldRate,
    CurrencyType currency = CurrencyType.inr,
  }) async {
    try {
      final response = await _apiService.dio.post(
        ApiConstants.transactions,
        data: {
          'customerId': customerId,
          'type': type.name
              .toUpperCase()
              .replaceAll('IN', '_IN')
              .replaceAll(
                'OUT',
                '_OUT',
              ), // Simplistic conversion to enum string
          'metalType': metalType == MetalType.jewellery
              ? 'JEWELLERY'
              : metalType.name.toUpperCase(),
          'weight': ?weight,
          'amount': ?amount,
          'remark': ?remark,
          'grossWeight': ?grossWeight,
          'stoneWeight': ?stoneWeight,
          'wastagePercent': ?wastagePercent,
          'goldRate': ?goldRate,
          'currency': currency.name.toUpperCase(),
        },
      );
      final responseData =
          (response.data is Map<String, dynamic> &&
              (response.data as Map<String, dynamic>).containsKey('data'))
          ? response.data['data']
          : response.data;
      return TransactionModel.fromJson(responseData);
    } on DioException catch (e) {
      final message = e.response?.data['message'];
      final String errorMessage = message is List
          ? message.join(', ')
          : (message?.toString() ?? 'Failed to create transaction');
      throw AppException(errorMessage);
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    try {
      final response = await _apiService.dio.get(ApiConstants.transactions);
      final List data =
          (response.data is Map<String, dynamic> &&
              (response.data as Map<String, dynamic>).containsKey('data'))
          ? response.data['data']
          : response.data;
      return data.map((json) => TransactionModel.fromJson(json)).toList();
    } on DioException catch (e) {
      final message = e.response?.data['message'];
      final String errorMessage = message is List
          ? message.join(', ')
          : (message?.toString() ?? 'Failed to fetch transactions');
      throw AppException(errorMessage);
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  Future<List<TransactionModel>> getTransactionsByCustomer(
    String customerId,
  ) async {
    try {
      final response = await _apiService.dio.get(
        ApiConstants.transactionsByCustomer(customerId),
      );
      final List data =
          (response.data is Map<String, dynamic> &&
              (response.data as Map<String, dynamic>).containsKey('data'))
          ? response.data['data']
          : response.data;
      return data.map((json) => TransactionModel.fromJson(json)).toList();
    } on DioException catch (e) {
      final message = e.response?.data['message'];
      final String errorMessage = message is List
          ? message.join(', ')
          : (message?.toString() ?? 'Failed to fetch transactions');
      throw AppException(errorMessage);
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
