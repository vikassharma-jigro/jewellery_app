import 'transaction_entity.dart';

class DashboardEntity {
  final double totalReceivables;
  final double totalPayables;
  final double totalGold;
  final double totalSilver;
  final List<TransactionEntity> recentTransactions;

  const DashboardEntity({
    required this.totalReceivables,
    required this.totalPayables,
    required this.totalGold,
    required this.totalSilver,
    required this.recentTransactions,
  });
}
