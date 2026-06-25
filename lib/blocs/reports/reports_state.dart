part of 'reports_cubit.dart';

abstract class ReportsState extends Equatable {

  const ReportsState();

  @override
  List<Object?> get props => [];
}

class ReportsInitial extends ReportsState {}

class ReportsLoading extends ReportsState {}

class DailyReportLoaded extends ReportsState {
  final DailyTransactionReportModel report;

  const DailyReportLoaded(this.report);

  @override
  List<Object?> get props => [report];
}

class MonthlyReportLoaded extends ReportsState {
  final MonthlySalesReportModel report;

  const MonthlyReportLoaded(this.report);

  @override
  List<Object?> get props => [report];
}

class ReportsError extends ReportsState {
  final String message;

  const ReportsError(this.message);

  @override
  List<Object?> get props => [message];
}
