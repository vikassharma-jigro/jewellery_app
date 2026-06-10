import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository.dart';

class CreateTransactionUsecase {
  final TransactionRepository repository;

  CreateTransactionUsecase(this.repository);

  Future<TransactionEntity> call(Map<String, dynamic> data) async {
    return await repository.createTransaction(data);
  }
}

class GetCustomerTransactionsUsecase {
  final TransactionRepository repository;

  GetCustomerTransactionsUsecase(this.repository);

  Future<List<TransactionEntity>> call(String customerId) async {
    return await repository.getCustomerTransactions(customerId);
  }
}
