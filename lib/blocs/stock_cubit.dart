import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/stock_repository.dart';
import '../data/models/stock_summary_model.dart';
import '../data/models/stock_ledger_entry_model.dart';
import '../core/exceptions.dart';

part 'stock_state.dart';

class StockCubit extends Cubit<StockState> {
  final StockRepository _stockRepository;

  StockCubit(this._stockRepository) : super(StockInitial());

  Future<void> fetchStockData() async {
    emit(StockLoading());
    try {
      final summary = await _stockRepository.getStockSummary();
      final ledger = await _stockRepository.getStockLedger();
      emit(StockLoaded(summary, ledger));
    } on AppException catch (e) {
      emit(StockError(e.message));
    } catch (e) {
      emit(StockError(e.toString()));
    }
  }
}
