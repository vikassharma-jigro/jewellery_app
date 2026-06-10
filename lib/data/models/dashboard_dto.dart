import '../../domain/entities/dashboard_entity.dart';
import 'transaction_dto.dart';

class DashboardDto {
  final double totalReceivables;
  final double totalPayables;
  final double totalGold;
  final double totalSilver;
  final List<TransactionDto> recentTransactions;

  DashboardDto({
    required this.totalReceivables,
    required this.totalPayables,
    required this.totalGold,
    required this.totalSilver,
    required this.recentTransactions,
  });

  factory DashboardDto.fromJson(Map<String, dynamic> json) {
    return DashboardDto(
      totalReceivables: (json['totalReceivables'] ?? 0).toDouble(),
      totalPayables: (json['totalPayables'] ?? 0).toDouble(),
      totalGold: (json['totalGold'] ?? 0).toDouble(),
      totalSilver: (json['totalSilver'] ?? 0).toDouble(),
      recentTransactions: (json['recentTransactions'] as List<dynamic>?)
              ?.map((e) => TransactionDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  DashboardEntity toEntity() {
    return DashboardEntity(
      totalReceivables: totalReceivables,
      totalPayables: totalPayables,
      totalGold: totalGold,
      totalSilver: totalSilver,
      recentTransactions: recentTransactions.map((e) => e.toEntity()).toList(),
    );
  }
}
