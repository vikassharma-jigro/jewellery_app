import 'package:equatable/equatable.dart';
import 'transaction_model.dart';

class DashboardSummaryModel extends Equatable {
  final double totalReceivables;
  final double totalPayables;
  final double goldStock;
  final double jewelleryStock;
  final List<TransactionModel> recentTransactions;

  const DashboardSummaryModel({
    this.totalReceivables = 0.0,
    this.totalPayables = 0.0,
    this.goldStock = 0.0,
    this.jewelleryStock = 0.0,
    this.recentTransactions = const [],
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryModel(
      totalReceivables: (json['totalReceivables'] ?? 0).toDouble(),
      totalPayables: (json['totalPayables'] ?? 0).toDouble(),
      goldStock: (json['totalGold'] ?? json['goldStock'] ?? 0).toDouble(),
      jewelleryStock: (json['totalJewellery'] ?? json['jewelleryStock'] ?? 0).toDouble(),
      recentTransactions: (json['recentTransactions'] as List<dynamic>?)
              ?.map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalReceivables': totalReceivables,
      'totalPayables': totalPayables,
      'goldStock': goldStock,
      'jewelleryStock': jewelleryStock,
      'recentTransactions': recentTransactions.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        totalReceivables,
        totalPayables,
        goldStock,
        jewelleryStock,
        recentTransactions,
      ];
}
