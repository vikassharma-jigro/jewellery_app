import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_api_service.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionApiService _apiService;

  TransactionRepositoryImpl(this._apiService);

  @override
  Future<TransactionEntity> createTransaction(Map<String, dynamic> data) async {
    try {
      final dto = await _apiService.createTransaction(data);
      return dto.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<TransactionEntity>> getCustomerTransactions(String customerId) async {
    try {
      final dtoList = await _apiService.getCustomerTransactions(customerId);
      return dtoList.map((dto) => dto.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }
}
