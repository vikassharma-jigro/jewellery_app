import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../repositories/reports_repository.dart';
import '../../data/models/report_model.dart';

part 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  final ReportsRepository _reportsRepository;

  ReportsCubit(this._reportsRepository) : super(ReportsInitial());

  Future<void> fetchDailyTransactions({String? date}) async {
    emit(ReportsLoading());
    try {
      final String queryDate =
          date ?? DateTime.now().toIso8601String().split('T')[0];
      final report = await _reportsRepository.getDailyTransactions(queryDate);
      emit(DailyReportLoaded(report));
    } catch (e) {
      emit(ReportsError(e.toString()));
    }
  }

  Future<void> fetchMonthlySales({String? month}) async {
    emit(ReportsLoading());
    try {
      final now = DateTime.now();
      final String queryMonth =
          month ?? "${now.year}-${now.month.toString().padLeft(2, '0')}";
      final report = await _reportsRepository.getMonthlySales(queryMonth);
      emit(MonthlyReportLoaded(report));
    } catch (e) {
      emit(ReportsError(e.toString()));
    }
  }

  Future<String> exportMonthlyReport(String yyyyMM) async {
    final parts = yyyyMM.split('-');
    if (parts.length != 2)
      throw Exception('Invalid month format. Expected YYYY-MM');
    final year = parts[0];
    final month = parts[1];
    return await _reportsRepository.exportMonthlyReport(month, year);
  }
}
