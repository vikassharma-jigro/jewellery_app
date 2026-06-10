import '../../domain/entities/stock_entity.dart';

abstract class StockRepository {
  Future<StockBalanceEntity> getGlobalBalance();
  Future<List<StockLedgerEntity>> getLedger();
}
