import 'package:equatable/equatable.dart';

class StockSummaryModel extends Equatable {
  final double totalGold;
  final double totalSilver;

  const StockSummaryModel({
    this.totalGold = 0.0,
    this.totalSilver = 0.0,
  });

  factory StockSummaryModel.fromJson(Map<String, dynamic> json) {
    return StockSummaryModel(
      totalGold: (json['totalGold'] ?? 0).toDouble(),
      totalSilver: (json['totalSilver'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalGold': totalGold,
      'totalSilver': totalSilver,
    };
  }

  @override
  List<Object?> get props => [totalGold, totalSilver];
}
