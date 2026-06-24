import 'package:equatable/equatable.dart';

class CustomerModel extends Equatable {
  final String id;
  final String name;
  final String? phone;
  final String? address;
  final String? aadhaar;
  final String? gst;
  final double goldBalance;
  final double jewelleryBalance;
  final double cashBalance;

  const CustomerModel({
    required this.id,
    required this.name,
    this.phone,
    this.address,
    this.aadhaar,
    this.gst,
    this.goldBalance = 0.0,
    this.jewelleryBalance = 0.0,
    this.cashBalance = 0.0,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      phone: json['mobile'] ?? json['phone'],
      address: json['address'],
      aadhaar: json['aadhaar'],
      gst: json['gst'],
      goldBalance: (json['goldBalance'] ?? 0).toDouble(),
      jewelleryBalance: (json['jewelleryBalance'] ?? 0).toDouble(),
      cashBalance: (json['paymentDue'] ?? json['cashBalance'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'aadhaar': aadhaar,
      'gst': gst,
      'goldBalance': goldBalance,
      'jewelleryBalance': jewelleryBalance,
      'cashBalance': cashBalance,
    };
  }

  @override
  List<Object?> get props => [id, name, phone, address, aadhaar, gst, goldBalance, jewelleryBalance, cashBalance];
}
