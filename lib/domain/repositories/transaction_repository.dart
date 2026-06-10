import '../../domain/entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future<TransactionEntity> createTransaction(Map<String, dynamic> data);
  Future<List<TransactionEntity>> getCustomerTransactions(String customerId);
}
