import 'package:dio/dio.dart';
import '../core/api_service.dart';
import '../core/constants.dart';
import '../core/exceptions.dart';
import '../data/models/dashboard_summary_model.dart';

class DashboardRepository {
  final ApiService _apiService;

  DashboardRepository(this._apiService);

  Future<DashboardSummaryModel> getDashboardSummary() async {
    try {
      final response = await _apiService.dio.get(ApiConstants.dashboardSummary);
      final responseData = response.data['data'] ?? response.data;
      return DashboardSummaryModel.fromJson(responseData);
    } on DioException catch (e) {
      throw AppException(e.response?.data['message'] ?? 'Failed to fetch dashboard summary');
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
