import 'package:equatable/equatable.dart';
import '../data/models/transaction_model.dart';
import '../data/models/customer_model.dart';

abstract class TransactionDetailState extends Equatable {
  const TransactionDetailState();

  @override
  List<Object?> get props => [];
}

class TransactionDetailLoading extends TransactionDetailState {}

class TransactionDetailLoaded extends TransactionDetailState {
  final TransactionModel transaction;
  final CustomerModel? customer;

  const TransactionDetailLoaded({
    required this.transaction,
    this.customer,
  });

  TransactionDetailLoaded copyWith({
    TransactionModel? transaction,
    CustomerModel? customer,
  }) {
    return TransactionDetailLoaded(
      transaction: transaction ?? this.transaction,
      customer: customer ?? this.customer,
    );
  }

  @override
  List<Object?> get props => [transaction, customer];
}

class TransactionDetailError extends TransactionDetailState {
  final String message;

  const TransactionDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
