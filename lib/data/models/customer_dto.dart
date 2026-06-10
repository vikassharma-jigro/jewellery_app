import '../../domain/entities/customer_entity.dart';

class CustomerDto {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? address;

  CustomerDto({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.address,
  });

  factory CustomerDto.fromJson(Map<String, dynamic> json) {
    return CustomerDto(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String?,
      address: json['address'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
    };
  }

  CustomerEntity toEntity() {
    return CustomerEntity(
      id: id,
      name: name,
      phone: phone,
      email: email,
      address: address,
    );
  }

  factory CustomerDto.fromEntity(CustomerEntity entity) {
    return CustomerDto(
      id: entity.id,
      name: entity.name,
      phone: entity.phone,
      email: entity.email,
      address: entity.address,
    );
  }
}
