abstract class MarketRateState {}

class MarketRateInitial extends MarketRateState {}
class MarketRateLoading extends MarketRateState {}
class MarketRateLoaded extends MarketRateState {
  final Map<String, dynamic> rates = {};
}
class MarketRateError extends MarketRateState {
  final String message;
  MarketRateError(this.message);
}
