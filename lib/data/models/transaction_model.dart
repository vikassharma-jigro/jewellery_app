import 'package:equatable/equatable.dart';

enum TransactionType { stockIn, stockOut, paymentIn, paymentOut }

enum MetalType { gold, jewellery, none }

enum CurrencyType { inr, usd, myr }

enum MakingChargeType { percentage, perGram, fixed }

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
  final double? purityPercent;
  final double? wastage;
  final double? finalWeight;
  final double? goldRate;
  final double? priceSegment;
  final MakingChargeType? makingChargeType;
  final double? makingChargeValue;
  final double? makingCharge;
  final double? totalAmount;
  final String? adminId;
  final CurrencyType currency;
  final int? calculationVersion;
  final DateTime createdAt;
  final DateTime? updatedAt;

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
    this.purityPercent,
    this.wastage,
    this.finalWeight,
    this.goldRate,
    this.priceSegment,
    this.makingChargeType,
    this.makingChargeValue,
    this.makingCharge,
    this.totalAmount,
    this.adminId,
    this.currency = CurrencyType.inr,
    this.calculationVersion,
    required this.createdAt,
    this.updatedAt,
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
      purityPercent: json['purityPercent']?.toDouble(),
      wastage: json['wastage']?.toDouble(),
      finalWeight: json['finalWeight']?.toDouble(),
      goldRate: json['goldRate']?.toDouble(),
      priceSegment: json['priceSegment']?.toDouble(),
      makingChargeType: _parseMakingChargeType(json['makingChargeType']),
      makingChargeValue: json['makingChargeValue']?.toDouble(),
      makingCharge: json['makingCharge']?.toDouble(),
      totalAmount: json['totalAmount']?.toDouble(),
      adminId: json['adminId']?.toString(),
      currency: _parseCurrencyType(json['currency']),
      calculationVersion: json['calculationVersion'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
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
      'purityPercent': purityPercent,
      'wastage': wastage,
      'finalWeight': finalWeight,
      'goldRate': goldRate,
      'priceSegment': priceSegment,
      'makingChargeType': makingChargeType != null ? _makingChargeTypeToString(makingChargeType!) : null,
      'makingChargeValue': makingChargeValue,
      'makingCharge': makingCharge,
      'totalAmount': totalAmount,
      'adminId': adminId,
      'currency': _currencyTypeToString(currency),
      'calculationVersion': calculationVersion,
      'createdAt': createdAt.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
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

  static MakingChargeType? _parseMakingChargeType(String? type) {
    switch (type) {
      case 'PERCENTAGE':
        return MakingChargeType.percentage;
      case 'PER_GRAM':
        return MakingChargeType.perGram;
      case 'FIXED':
        return MakingChargeType.fixed;
      default:
        return null;
    }
  }

  static String _makingChargeTypeToString(MakingChargeType type) {
    switch (type) {
      case MakingChargeType.percentage:
        return 'PERCENTAGE';
      case MakingChargeType.perGram:
        return 'PER_GRAM';
      case MakingChargeType.fixed:
        return 'FIXED';
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
    purityPercent,
    wastage,
    finalWeight,
    goldRate,
    priceSegment,
    makingChargeType,
    makingChargeValue,
    makingCharge,
    totalAmount,
    adminId,
    currency,
    calculationVersion,
    createdAt,
    updatedAt,
  ];
}
