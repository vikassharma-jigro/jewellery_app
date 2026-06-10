import '../entities/dashboard_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardSummaryUsecase {
  final DashboardRepository repository;

  GetDashboardSummaryUsecase(this.repository);

  Future<DashboardEntity> call() async {
    return await repository.getDashboardSummary();
  }
}
