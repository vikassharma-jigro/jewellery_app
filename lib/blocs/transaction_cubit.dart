import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/transaction_repository.dart';
import '../data/models/transaction_model.dart';
import '../core/utils/exceptions.dart';

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final TransactionRepository _transactionRepository;

  TransactionCubit(this._transactionRepository) : super(TransactionInitial());

  Future<void> fetchTransactions() async {
    emit(TransactionLoading());
    try {
      final transactions = await _transactionRepository.getAllTransactions();
      emit(TransactionLoaded(transactions));
    } on AppException catch (e) {
      emit(TransactionError(e.message));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> fetchTransactionsByCustomer(String customerId) async {
    emit(TransactionLoading());
    try {
      final transactions = await _transactionRepository
          .getTransactionsByCustomer(customerId);
      emit(TransactionLoaded(transactions));
    } on AppException catch (e) {
      emit(TransactionError(e.message));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> createTransaction({
    required String customerId,
    required TransactionType type,
    required MetalType metalType,
    double? weight,
    double? amount,
    String? remark,
    double? grossWeight,
    double? stoneWeight,
    double? purityPercent,
    double? goldRate,
    MakingChargeType? makingChargeType,
    double? makingChargesValue,
    CurrencyType currency = CurrencyType.inr,
    String? linkedTransactionId,
  }) async {
    emit(TransactionLoading());
    try {
      await _transactionRepository.createTransaction(
        customerId: customerId,
        type: type,
        metalType: metalType,
        weight: weight,
        amount: amount,
        remark: remark,
        grossWeight: grossWeight,
        stoneWeight: stoneWeight,
        wastagePercent: purityPercent,
        goldRate: goldRate,
        makingChargeType: makingChargeType,
        makingChargesValue: makingChargesValue,
        currency: currency,
        linkedTransactionId: linkedTransactionId,
      );
      emit(TransactionCreated());
      fetchTransactionsByCustomer(customerId);
    } on AppException catch (e) {
      emit(TransactionError(e.message));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }
}
