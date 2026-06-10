import 'package:equatable/equatable.dart';

enum TransactionType { stockIn, stockOut, paymentIn, paymentOut }

enum MetalType { gold, jewellery, none }

enum CurrencyType { inr, usd, myr }

class TransactionModel extends Equatable {
  final String id;
  final String customerId;
  final String? customerName;
  final TransactionType type;
  final MetalType metalType;
  final double? weight;
  final double? amount;
  final String? remark;
  final double? grossWeight;
  final double? stoneWeight;
  final double? netWeight;
  final double? wastagePercent;
  final double? wastage;
  final double? finalWeight;
  final double? goldRate;
  final double? totalAmount;
  final CurrencyType currency;
  final DateTime createdAt;

  const TransactionModel({
    required this.id,
    required this.customerId,
    this.customerName,
    required this.type,
    required this.metalType,
    this.weight,
    this.amount,
    this.remark,
    this.grossWeight,
    this.stoneWeight,
    this.netWeight,
    this.wastagePercent,
    this.wastage,
    this.finalWeight,
    this.goldRate,
    this.totalAmount,
    this.currency = CurrencyType.inr,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    String pCustomerId = '';
    String? pCustomerName;

    if (json['customerId'] is Map) {
      pCustomerId =
          json['customerId']['_id']?.toString() ??
          json['customerId']['id']?.toString() ??
          '';
      pCustomerName = json['customerId']['name']?.toString();
    } else {
      pCustomerId = json['customerId']?.toString() ?? '';
    }

    return TransactionModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      customerId: pCustomerId,
      customerName: pCustomerName,
      type: _parseTransactionType(json['type']),
      metalType: _parseMetalType(json['metalType']),
      weight: json['weight']?.toDouble(),
      amount: json['amount']?.toDouble(),
      remark: json['remark'],
      grossWeight: json['grossWeight']?.toDouble(),
      stoneWeight: json['stoneWeight']?.toDouble(),
      netWeight: json['netWeight']?.toDouble(),
      wastagePercent: json['wastagePercent']?.toDouble(),
      wastage: json['wastage']?.toDouble(),
      finalWeight: json['finalWeight']?.toDouble(),
      goldRate: json['goldRate']?.toDouble(),
      totalAmount: json['totalAmount']?.toDouble(),
      currency: _parseCurrencyType(json['currency']),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'type': _transactionTypeToString(type),
      'metalType': _metalTypeToString(metalType),
      'weight': weight,
      'amount': amount,
      'remark': remark,
      'grossWeight': grossWeight,
      'stoneWeight': stoneWeight,
      'netWeight': netWeight,
      'wastagePercent': wastagePercent,
      'wastage': wastage,
      'finalWeight': finalWeight,
      'goldRate': goldRate,
      'totalAmount': totalAmount,
      'currency': _currencyTypeToString(currency),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static TransactionType _parseTransactionType(String? type) {
    switch (type) {
      case 'STOCK_IN':
        return TransactionType.stockIn;
      case 'STOCK_OUT':
        return TransactionType.stockOut;
      case 'PAYMENT_IN':
        return TransactionType.paymentIn;
      case 'PAYMENT_OUT':
        return TransactionType.paymentOut;
      default:
        return TransactionType.paymentIn; // default or throw
    }
  }

  static String _transactionTypeToString(TransactionType type) {
    switch (type) {
      case TransactionType.stockIn:
        return 'STOCK_IN';
      case TransactionType.stockOut:
        return 'STOCK_OUT';
      case TransactionType.paymentIn:
        return 'PAYMENT_IN';
      case TransactionType.paymentOut:
        return 'PAYMENT_OUT';
    }
  }

  static MetalType _parseMetalType(String? type) {
    switch (type) {
      case 'GOLD':
        return MetalType.gold;
      case 'JEWELLERY':
        return MetalType.jewellery;

      case 'NONE':
      default:
        return MetalType.none;
    }
  }

  static String _metalTypeToString(MetalType type) {
    switch (type) {
      case MetalType.gold:
        return 'GOLD';
      case MetalType.jewellery:
        return 'JEWELLERY';
      case MetalType.none:
        return 'NONE';
    }
  }

  static CurrencyType _parseCurrencyType(String? type) {
    switch (type) {
      case 'USD':
        return CurrencyType.usd;
      case 'MYR':
        return CurrencyType.myr;
      case 'INR':
      default:
        return CurrencyType.inr;
    }
  }

  static String _currencyTypeToString(CurrencyType type) {
    switch (type) {
      case CurrencyType.usd:
        return 'USD';
      case CurrencyType.myr:
        return 'MYR';
      case CurrencyType.inr:
        return 'INR';
    }
  }

  @override
  List<Object?> get props => [
    id,
    customerId,
    customerName,
    type,
    metalType,
    weight,
    amount,
    remark,
    grossWeight,
    stoneWeight,
    netWeight,
    wastagePercent,
    wastage,
    finalWeight,
    goldRate,
    totalAmount,
    currency,
    createdAt,
  ];
}
