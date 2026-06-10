import 'package:equatable/equatable.dart';
import '../../domain/entities/stock_entity.dart';

abstract class StockState extends Equatable {
  const StockState();

  @override
  List<Object?> get props => [];
}

class StockInitial extends StockState {}

class StockLoading extends StockState {}

class StockLoaded extends StockState {
  final List<dynamic> items = [];
  final String message = '';
  final StockBalanceEntity balance;
  final List<StockLedgerEntity> ledger;

  StockLoaded({required this.balance, required this.ledger});

  @override
  List<Object?> get props => [balance, ledger];
}

class StockError extends StockState {
  final String message;

  const StockError(this.message);

  @override
  List<Object?> get props => [message];
}
