import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../core/api_service.dart';
import '../core/constants.dart';
import '../core/exceptions.dart';
import '../data/models/report_model.dart';

class ReportsRepository {
  final ApiService _apiService;

  ReportsRepository(this._apiService);

  Future<DailyTransactionReportModel> getDailyTransactions(String date) async {
    try {
      final response = await _apiService.dio.get(
        ApiConstants.dailyTransactionsReport,
        queryParameters: {'date': date},
      );
      final data = (response.data is Map<String, dynamic> &&
              (response.data as Map<String, dynamic>).containsKey('data'))
          ? response.data['data']
          : response.data;
      return DailyTransactionReportModel.fromJson(data);
    } on DioException catch (e) {
      final message = e.response?.data['message'];
      final String errorMessage = message is List
          ? message.join(', ')
          : (message?.toString() ?? 'Failed to fetch daily transactions report');
      throw AppException(errorMessage);
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  Future<MonthlySalesReportModel> getMonthlySales(String month) async {
    try {
      final response = await _apiService.dio.get(
        ApiConstants.monthlySalesReport,
        queryParameters: {'month': month},
      );
      final data = (response.data is Map<String, dynamic> &&
              (response.data as Map<String, dynamic>).containsKey('data'))
          ? response.data['data']
          : response.data;
      return MonthlySalesReportModel.fromJson(data);
    } on DioException catch (e) {
      final message = e.response?.data['message'];
      final String errorMessage = message is List
          ? message.join(', ')
          : (message?.toString() ?? 'Failed to fetch monthly sales report');
      throw AppException(errorMessage);
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  Future<String> exportMonthlyReport(String month, String year) async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String savePath = '${tempDir.path}/monthly-report-$month-$year.xlsx';

      await _apiService.dio.download(
        ApiConstants.monthlySalesReportExport,
        savePath,
        queryParameters: {'month': month, 'year': year},
      );
      
      return savePath;
    } on DioException catch (e) {
      final message = e.response?.data?['message'];
      final String errorMessage = message is List
          ? message.join(', ')
          : (message?.toString() ?? 'Failed to export monthly sales report');
      throw AppException(errorMessage);
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
