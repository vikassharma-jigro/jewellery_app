import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_api_service.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardApiService _apiService;

  DashboardRepositoryImpl(this._apiService);

  @override
  Future<DashboardEntity> getDashboardSummary() async {
    try {
      final dto = await _apiService.getDashboardSummary();
      return dto.toEntity();
    } catch (e) {
      rethrow;
    }
  }
}
