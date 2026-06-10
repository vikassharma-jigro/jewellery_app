import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/transaction_usecases.dart';
import 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  void fetchReceivables() {}
  void fetchTransactions() {}
  final CreateTransactionUsecase _createTransactionUsecase;
  final GetCustomerTransactionsUsecase _getCustomerTransactionsUsecase;

  TransactionCubit(
    this._createTransactionUsecase,
    this._getCustomerTransactionsUsecase,
  ) : super(TransactionInitial());

  Future<void> fetchCustomerTransactions(String customerId) async {
    emit(TransactionLoading());
    try {
      final transactions = await _getCustomerTransactionsUsecase.call(customerId);
      emit(TransactionLoaded(transactions));
    } catch (e) {
      emit(TransactionError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> createTransaction(Map<String, dynamic> data) async {
    final currentState = state;
    emit(TransactionLoading());
    try {
      await _createTransactionUsecase.call(data);
      emit(const TransactionActionSuccess('Transaction created successfully'));
      
      // If we have a customerId, refresh their transactions
      if (data['customerId'] != null) {
        fetchCustomerTransactions(data['customerId']);
      }
    } catch (e) {
      emit(TransactionError(e.toString().replaceAll('Exception: ', '')));
      if (currentState is TransactionLoaded) {
        emit(currentState);
      }
    }
  }
}
