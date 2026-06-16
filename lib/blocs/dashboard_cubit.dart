import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/dashboard_repository.dart';
import '../data/models/dashboard_summary_model.dart';
import '../core/utils/exceptions.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository _dashboardRepository;

  DashboardCubit(this._dashboardRepository) : super(DashboardInitial());

  Future<void> fetchDashboardSummary() async {
    emit(DashboardLoading());
    try {
      final summary = await _dashboardRepository.getDashboardSummary();
      emit(DashboardLoaded(summary));
    } on AppException catch (e) {
      emit(DashboardError(e.message));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
