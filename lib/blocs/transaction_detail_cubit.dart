import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/transaction_repository.dart';
import '../repositories/customer_repository.dart';
import '../core/utils/exceptions.dart';
import 'transaction_detail_state.dart';

class TransactionDetailCubit extends Cubit<TransactionDetailState> {
  final TransactionRepository _transactionRepository;
  final CustomerRepository _customerRepository;

  TransactionDetailCubit(this._transactionRepository, this._customerRepository)
      : super(TransactionDetailLoading());

  Future<void> fetchTransactionDetail(String transactionId) async {
    emit(TransactionDetailLoading());
    try {
      final transaction = await _transactionRepository.getTransactionById(transactionId);
      
      emit(TransactionDetailLoaded(transaction: transaction));

      // Try to fetch customer details if we have a customerId
      if (transaction.customerId.isNotEmpty) {
        try {
          final customer = await _customerRepository.getCustomerById(transaction.customerId);
          if (state is TransactionDetailLoaded) {
            final currentState = state as TransactionDetailLoaded;
            emit(currentState.copyWith(customer: customer));
          }
        } catch (e) {
          // It's okay if customer fetch fails, we still show transaction details
        }
      }
    } on AppException catch (e) {
      emit(TransactionDetailError(e.message));
    } catch (e) {
      emit(TransactionDetailError(e.toString()));
    }
  }
}
