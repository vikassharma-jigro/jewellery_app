import 'package:equatable/equatable.dart';

enum TransactionType {
  purchase,
  purchaseReturn,
  sales,
  salesReturn,
  cashJama,
  cashNamae,
  metalJama,
  metalNamae,
}

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
  final String? linkedTransactionId;

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
    this.linkedTransactionId,
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
      linkedTransactionId: json['linkedTransactionId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'type': transactionTypeToString(type),
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
      'makingChargeType': makingChargeType != null
          ? _makingChargeTypeToString(makingChargeType!)
          : null,
      'makingChargeValue': makingChargeValue,
      'makingCharge': makingCharge,
      'totalAmount': totalAmount,
      'adminId': adminId,
      'currency': _currencyTypeToString(currency),
      'calculationVersion': calculationVersion,
      'createdAt': createdAt.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      'linkedTransactionId': linkedTransactionId,
    };
  }

  static TransactionType _parseTransactionType(String? type) {
    switch (type) {
      case 'PURCHASE':
        return TransactionType.purchase;
      case 'PURCHASE_RETURN':
        return TransactionType.purchaseReturn;
      case 'SALES':
        return TransactionType.sales;
      case 'SALES_RETURN':
        return TransactionType.salesReturn;
      case 'CASH_JAMA':
        return TransactionType.cashJama;
      case 'CASH_NAMAE':
        return TransactionType.cashNamae;
      case 'METAL_JAMA':
        return TransactionType.metalJama;
      case 'METAL_NAMAE':
        return TransactionType.metalNamae;
      default:
        return TransactionType.cashJama;
    }
  }

  static String transactionTypeToString(TransactionType type) {
    switch (type) {
      case TransactionType.purchase:
        return 'PURCHASE';
      case TransactionType.purchaseReturn:
        return 'PURCHASE_RETURN';
      case TransactionType.sales:
        return 'SALES';
      case TransactionType.salesReturn:
        return 'SALES_RETURN';
      case TransactionType.cashJama:
        return 'CASH_JAMA';
      case TransactionType.cashNamae:
        return 'CASH_NAMAE';
      case TransactionType.metalJama:
        return 'METAL_JAMA';
      case TransactionType.metalNamae:
        return 'METAL_NAMAE';
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
    linkedTransactionId,
  ];
}
