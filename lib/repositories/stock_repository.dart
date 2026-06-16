import 'package:dio/dio.dart';
import '../core/utils/api_service.dart';
import '../core/utils/constants.dart';
import '../core/utils/exceptions.dart';
import '../data/models/stock_summary_model.dart';
import '../data/models/stock_ledger_entry_model.dart';

class StockRepository {
  final ApiService _apiService;

  StockRepository(this._apiService);

  Future<StockSummaryModel> getStockSummary() async {
    try {
      final response = await _apiService.dio.get(ApiConstants.stockSummary);
      final responseData =
          (response.data is Map<String, dynamic> &&
              (response.data as Map<String, dynamic>).containsKey('data'))
          ? response.data['data']
          : response.data;
      return StockSummaryModel.fromJson(responseData);
    } on DioException catch (e) {
      throw AppException(
        e.response?.data['message'] ?? 'Failed to fetch stock summary',
      );
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  Future<List<StockLedgerEntryModel>> getStockLedger() async {
    try {
      final response = await _apiService.dio.get(ApiConstants.stockLedger);
      final List data =
          (response.data is Map<String, dynamic> &&
              (response.data as Map<String, dynamic>).containsKey('data'))
          ? response.data['data']
          : response.data;
      return data.map((json) => StockLedgerEntryModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw AppException(
        e.response?.data['message'] ?? 'Failed to fetch stock ledger',
      );
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
