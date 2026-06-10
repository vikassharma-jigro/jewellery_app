import '../../domain/entities/transaction_entity.dart';

class TransactionDto {
  final String id;
  final String? customerId;
  final String? customerName;
  final double weight;
  final String metalType;
  final String type;
  final String? remarks;
  final DateTime createdAt;

  TransactionDto({
    required this.id,
    this.customerId,
    this.customerName,
    required this.weight,
    required this.metalType,
    required this.type,
    this.remarks,
    required this.createdAt,
  });

  factory TransactionDto.fromJson(Map<String, dynamic> json) {
    String? cName;
    if (json['customerId'] is Map) {
      cName = json['customerId']['name'];
    }
    return TransactionDto(
      id: json['_id'] ?? json['id'] ?? '',
      customerId: json['customerId'] is Map ? json['customerId']['_id'] : json['customerId'],
      customerName: cName,
      weight: (json['weight'] ?? 0).toDouble(),
      metalType: json['metalType'] ?? 'GOLD',
      type: json['type'] ?? 'IN',
      remarks: json['remarks'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }

  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      customerId: customerId,
      customerName: customerName,
      weight: weight,
      metalType: metalType,
      type: type,
      remarks: remarks,
      createdAt: createdAt,
    );
  }
}
