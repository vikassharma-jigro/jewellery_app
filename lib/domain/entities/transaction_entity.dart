class TransactionEntity {
  final String id;
  final String? customerId;
  final String? customerName;
  final double weight;
  final String metalType; // GOLD, SILVER
  final String type; // IN, OUT
  final String? remarks;
  final DateTime createdAt;

  const TransactionEntity({
    required this.id,
    this.customerId,
    this.customerName,
    required this.weight,
    required this.metalType,
    required this.type,
    this.remarks,
    required this.createdAt,
  });
}
