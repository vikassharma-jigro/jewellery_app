part of 'stock_cubit.dart';

abstract class StockState extends Equatable {
  const StockState();

  @override
  List<Object?> get props => [];
}

class StockInitial extends StockState {}

class StockLoading extends StockState {}

class StockLoaded extends StockState {
  final StockSummaryModel summary;
  final List<StockLedgerEntryModel> ledger;

  const StockLoaded(this.summary, this.ledger);

  @override
  List<Object?> get props => [summary, ledger];
}

class StockError extends StockState {
  final String message;

  const StockError(this.message);

  @override
  List<Object?> get props => [message];
}
