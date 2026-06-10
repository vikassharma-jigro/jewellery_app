import '../entities/stock_entity.dart';
import '../repositories/stock_repository.dart';

class GetGlobalBalanceUsecase {
  final StockRepository repository;

  GetGlobalBalanceUsecase(this.repository);

  Future<StockBalanceEntity> call() async {
    return await repository.getGlobalBalance();
  }
}

class GetStockLedgerUsecase {
  final StockRepository repository;

  GetStockLedgerUsecase(this.repository);

  Future<List<StockLedgerEntity>> call() async {
    return await repository.getLedger();
  }
}
