import 'package:equatable/equatable.dart';
import 'transaction_model.dart';

class StockLedgerEntryModel extends Equatable {
  final String id;
  final String? transactionId;
  final TransactionType type;
  final MetalType metalType;
  final double weight;
  final String? remark;
  final DateTime createdAt;
  final double balanceAfter;

  const StockLedgerEntryModel({
    required this.id,
    this.transactionId,
    required this.type,
    required this.metalType,
    required this.weight,
    this.remark,
    required this.createdAt,
    required this.balanceAfter,
  });

  factory StockLedgerEntryModel.fromJson(Map<String, dynamic> json) {
    // Assuming same type enums
    MetalType parsedMetalType;
    switch (json['metalType']) {
      case 'GOLD':
        parsedMetalType = MetalType.gold;
        break;
      case 'JEWELLERY':
        parsedMetalType = MetalType.jewellery;
        break;
      default:
        parsedMetalType = MetalType.none;
    }

    TransactionType parsedTxType;
    switch (json['type']) {
      case 'STOCK_IN':
      case 'IN':
        parsedTxType = TransactionType.stockIn;
        break;
      case 'STOCK_OUT':
      case 'OUT':
        parsedTxType = TransactionType.stockOut;
        break;
      default:
        parsedTxType = TransactionType.stockIn;
    }

    return StockLedgerEntryModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      transactionId: json['transactionId']?.toString(),
      type: parsedTxType,
      metalType: parsedMetalType,
      weight: (json['weight'] ?? 0).toDouble(),
      remark: json['remark'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      balanceAfter: (json['balanceAfter'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type == TransactionType.stockIn ? 'STOCK_IN' : 'STOCK_OUT',
      'metalType': metalType == MetalType.gold
          ? 'GOLD'
          : (metalType == MetalType.jewellery ? 'JEWELLERY' : 'NONE'),
      'weight': weight,
      'remark': remark,
      'createdAt': createdAt.toIso8601String(),
      'balanceAfter': balanceAfter,
    };
  }

  @override
  List<Object?> get props => [
    id,
    transactionId,
    type,
    metalType,
    weight,
    remark,
    createdAt,
    balanceAfter,
  ];
}
