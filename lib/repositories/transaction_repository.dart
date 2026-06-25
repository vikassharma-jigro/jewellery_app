import 'package:dio/dio.dart';
import '../core/utils/api_service.dart';
import '../core/utils/constants.dart';
import '../core/utils/exceptions.dart';
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
    MakingChargeType? makingChargeType,
    double? makingChargesValue,
    CurrencyType currency = CurrencyType.inr,
    String? linkedTransactionId,
  }) async {
    try {
      final response = await _apiService.dio.post(
        ApiConstants.transactions,
        data: {
          'customerId': customerId,
          'type': TransactionModel.transactionTypeToString(type),
          'metalType': metalType == MetalType.jewellery
              ? 'JEWELLERY'
              : metalType.name.toUpperCase(),
          'currency': currency.name.toUpperCase(),
          if (weight != null) 'weight': weight,
          if (amount != null) 'amount': amount,
          if (remark != null) 'remark': remark,
          if (grossWeight != null) 'grossWeight': grossWeight,
          if (stoneWeight != null) 'stoneWeight': stoneWeight,
          if (wastagePercent != null) 'purityPercent': wastagePercent,
          if (goldRate != null) 'goldRate': goldRate,
          if (makingChargeType != null) 'makingChargeType': makingChargeType.name.toUpperCase().replaceAll('PERGRAM', 'PER_GRAM'),
          if (makingChargesValue != null) 'makingChargesValue': makingChargesValue,
          if (linkedTransactionId != null) 'linkedTransactionId': linkedTransactionId,
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

  Future<TransactionModel> getTransactionById(String id) async {
    try {
      final response = await _apiService.dio.get(ApiConstants.transactionDetails(id));
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
          : (message?.toString() ?? 'Failed to fetch transaction details');
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
