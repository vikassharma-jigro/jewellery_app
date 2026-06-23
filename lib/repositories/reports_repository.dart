import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../core/utils/api_service.dart';
import '../core/utils/constants.dart';
import '../core/utils/exceptions.dart';
import '../data/models/report_model.dart';
import 'package:permission_handler/permission_handler.dart';

class ReportsRepository {
  final ApiService _apiService;

  ReportsRepository(this._apiService);

  Future<DailyTransactionReportModel> getDailyTransactions(String date) async {
    try {
      final response = await _apiService.dio.get(
        ApiConstants.dailyTransactionsReport,
        queryParameters: {'date': date},
      );
      final data =
          (response.data is Map<String, dynamic> &&
              (response.data as Map<String, dynamic>).containsKey('data'))
          ? response.data['data']
          : response.data;
      return DailyTransactionReportModel.fromJson(data);
    } on DioException catch (e) {
      final message = e.response?.data['message'];
      final String errorMessage = message is List
          ? message.join(', ')
          : (message?.toString() ??
                'Failed to fetch daily transactions report');
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
      final data =
          (response.data is Map<String, dynamic> &&
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
      Directory? directory;
      String savePath = '';
      String fileName = 'monthly-report-$month-$year-${DateTime.now().millisecondsSinceEpoch}.xlsx';

      if (Platform.isAndroid) {
        // Fallback directory
        final fallbackDir = await getExternalStorageDirectory();
        
        try {
          var status = await Permission.storage.status;
          if (!status.isGranted) {
            await Permission.storage.request();
          }

          directory = Directory('/storage/emulated/0/Download');
          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }
          savePath = '${directory.path}/$fileName';
          
          // Test if we can write to this directory
          final testFile = File(savePath);
          await testFile.writeAsBytes([]);
          await testFile.delete();
        } catch (e) {
          // If permission denied or directory not accessible, use fallback
          directory = fallbackDir;
          savePath = '${directory?.path}/$fileName';
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
        savePath = '${directory.path}/$fileName';
      }

      if (directory == null) {
        directory = await getTemporaryDirectory();
        savePath = '${directory.path}/$fileName';
      }

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
