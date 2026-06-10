import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/dashboard_usecases.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final GetDashboardSummaryUsecase _getDashboardSummaryUsecase;

  DashboardCubit(this._getDashboardSummaryUsecase) : super(DashboardInitial());

  Future<void> loadDashboard() async {
    emit(DashboardLoading());
    try {
      final dashboard = await _getDashboardSummaryUsecase.call();
      emit(DashboardLoaded(dashboard));
    } catch (e) {
      emit(DashboardError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
