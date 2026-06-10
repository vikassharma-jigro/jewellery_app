import os

# market_rate_cubit.dart
market_rate_cubit = """import 'package:flutter_bloc/flutter_bloc.dart';
import 'market_rate_state.dart';

class MarketRateCubit extends Cubit<MarketRateState> {
  MarketRateCubit() : super(MarketRateInitial());

  void fetchRates() {
    emit(MarketRateLoading());
    emit(MarketRateLoaded());
  }
}
"""

# market_rate_state.dart
market_rate_state = """abstract class MarketRateState {}

class MarketRateInitial extends MarketRateState {}
class MarketRateLoading extends MarketRateState {}
class MarketRateLoaded extends MarketRateState {
  final List<dynamic> rates = [];
}
class MarketRateError extends MarketRateState {
  final String message;
  MarketRateError(this.message);
}
"""

with open("/Users/apple/Documents/flutterdev/projects/office_projects/jewellery_app/lib/presentation/state/market_rate_cubit.dart", "w") as f:
    f.write(market_rate_cubit)
    
with open("/Users/apple/Documents/flutterdev/projects/office_projects/jewellery_app/lib/presentation/state/market_rate_state.dart", "w") as f:
    f.write(market_rate_state)
