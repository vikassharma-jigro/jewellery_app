import 'package:jewellary_stock/core/network/api_endpoints.dart';

class ApiConstants {
  // Use 127.0.0.1 for iOS simulator / MacOS. If using an Android emulator, change to 10.0.2.2
  static const String baseUrl = ApiEndpoints.baseUrl;

  static const String login = '/auth/login';
  static const String refresh = '/auth/refresh';

  static const String dashboardSummary = '/dashboard/summary';

  static const String customers = '/customers';

  static const String transactions = '/transactions';

  static String transactionsByCustomer(String id) =>
      '/transactions/customers/$id';

  static String transactionDetails(String id) => '/transactions/$id';

  static const String stockSummary = '/stock/summary';
  static const String stockLedger = '/stock/ledger';

  static const String dailyTransactionsReport = '/reports/daily-transactions';
  static const String monthlySalesReport = '/reports/monthly-sales';
  static const String monthlySalesReportExport = '/reports/monthly/export';
}
