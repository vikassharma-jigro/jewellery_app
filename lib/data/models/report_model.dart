import 'transaction_model.dart';

class DailyTransactionReportModel {
  final String date;
  final DailyReportSummary summary;
  final List<TransactionModel> transactions;

  DailyTransactionReportModel({
    required this.date,
    required this.summary,
    required this.transactions,
  });

  factory DailyTransactionReportModel.fromJson(Map<String, dynamic> json) {
    return DailyTransactionReportModel(
      date: json['date'] as String? ?? '',
      summary: DailyReportSummary.fromJson(json['summary'] ?? {}),
      transactions: (json['transactions'] as List?)
              ?.map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class DailyReportSummary {
  final DailyReportSummaryDetails inDetails;
  final DailyReportSummaryDetails outDetails;

  DailyReportSummary({
    required this.inDetails,
    required this.outDetails,
  });

  factory DailyReportSummary.fromJson(Map<String, dynamic> json) {
    return DailyReportSummary(
      inDetails: DailyReportSummaryDetails.fromJson(json['IN'] ?? {}),
      outDetails: DailyReportSummaryDetails.fromJson(json['OUT'] ?? {}),
    );
  }
}

class DailyReportSummaryDetails {
  final double totalQuantity;
  final double totalAmount;
  final int count;

  DailyReportSummaryDetails({
    required this.totalQuantity,
    required this.totalAmount,
    required this.count,
  });

  factory DailyReportSummaryDetails.fromJson(Map<String, dynamic> json) {
    return DailyReportSummaryDetails(
      totalQuantity: (json['totalQuantity'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      count: (json['count'] as num?)?.toInt() ?? 0,
    );
  }
}

class MonthlySalesReportModel {
  final String month;
  final double totalSales;
  final double totalQuantity;
  final int totalTransactions;

  MonthlySalesReportModel({
    required this.month,
    required this.totalSales,
    required this.totalQuantity,
    required this.totalTransactions,
  });

  factory MonthlySalesReportModel.fromJson(Map<String, dynamic> json) {
    return MonthlySalesReportModel(
      month: json['month'] as String? ?? '',
      totalSales: (json['totalSales'] as num?)?.toDouble() ?? 0.0,
      totalQuantity: (json['totalQuantity'] as num?)?.toDouble() ?? 0.0,
      totalTransactions: (json['totalTransactions'] as num?)?.toInt() ?? 0,
    );
  }
}
