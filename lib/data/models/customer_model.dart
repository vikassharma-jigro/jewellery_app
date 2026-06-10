import 'package:equatable/equatable.dart';

class CustomerModel extends Equatable {
  final String id;
  final String name;
  final String? phone;
  final double goldBalance;
  final double silverBalance;
  final double cashBalance;

  const CustomerModel({
    required this.id,
    required this.name,
    this.phone,
    this.goldBalance = 0.0,
    this.silverBalance = 0.0,
    this.cashBalance = 0.0,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      phone: json['mobile'] ?? json['phone'],
      goldBalance: (json['goldBalance'] ?? 0).toDouble(),
      silverBalance: (json['silverBalance'] ?? 0).toDouble(),
      cashBalance: (json['paymentDue'] ?? json['cashBalance'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'goldBalance': goldBalance,
      'silverBalance': silverBalance,
      'cashBalance': cashBalance,
    };
  }

  @override
  List<Object?> get props => [id, name, phone, goldBalance, silverBalance, cashBalance];
}
