import '../../domain/entities/stock_entity.dart';
import '../../domain/repositories/stock_repository.dart';
import '../datasources/stock_api_service.dart';

class StockRepositoryImpl implements StockRepository {
  final StockApiService _apiService;

  StockRepositoryImpl(this._apiService);

  @override
  Future<StockBalanceEntity> getGlobalBalance() async {
    try {
      final dto = await _apiService.getGlobalBalance();
      return dto.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<StockLedgerEntity>> getLedger() async {
    try {
      final dtoList = await _apiService.getLedger();
      return dtoList.map((dto) => dto.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }
}
