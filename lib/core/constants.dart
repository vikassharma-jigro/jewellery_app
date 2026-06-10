class ApiConstants {
  // Use 127.0.0.1 for iOS simulator / MacOS. If using an Android emulator, change to 10.0.2.2
  static const String baseUrl = 'http://127.0.0.1:3000/api'; 

  static const String login = '/auth/login';
  static const String refresh = '/auth/refresh';

  static const String dashboardSummary = '/dashboard/summary';

  static const String customers = '/customers';

  static const String transactions = '/transactions';
  
  static String transactionsByCustomer(String id) => '/transactions/customers/$id';

  static const String stockSummary = '/stock/summary';
  static const String stockLedger = '/stock/ledger';
}
