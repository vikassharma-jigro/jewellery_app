import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/stock_usecases.dart';
import 'stock_state.dart';

class StockCubit extends Cubit<StockState> {
  void fetchInventory() {}
  void addItem(dynamic item) {}
  final GetGlobalBalanceUsecase _getGlobalBalanceUsecase;
  final GetStockLedgerUsecase _getStockLedgerUsecase;

  StockCubit(
    this._getGlobalBalanceUsecase,
    this._getStockLedgerUsecase,
  ) : super(StockInitial());

  Future<void> loadStockData() async {
    emit(StockLoading());
    try {
      final balance = await _getGlobalBalanceUsecase.call();
      final ledger = await _getStockLedgerUsecase.call();
      
      emit(StockLoaded(balance: balance, ledger: ledger));
    } catch (e) {
      emit(StockError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
