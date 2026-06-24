class ApiEndpoints {
  // static const String baseUrl = 'http://127.0.0.1:3000/api';
  static const String baseUrl = 'http://157.20.51.180:4007/api';
  // static const String baseUrl = 'http://192.168.1.28:3000/api';

  // Auth endpoints
  static const String login = '/auth/login';

  // Customer endpoints
  static const String customers = '/customers';

  // Reports
  static const String dailyTransactionsReport = '/reports/daily-transactions';
  static const String monthlySalesReport = '/reports/monthly-sales';
  static const String monthlySalesReportExport =
      '/reports/monthly-sales/export';
}
