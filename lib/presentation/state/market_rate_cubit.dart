import 'package:flutter_bloc/flutter_bloc.dart';
import 'market_rate_state.dart';

class MarketRateCubit extends Cubit<MarketRateState> {
  MarketRateCubit() : super(MarketRateInitial());

  void fetchRates() {
    emit(MarketRateLoading());
    emit(MarketRateLoaded());
  }
}
