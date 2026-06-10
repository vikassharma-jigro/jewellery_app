class CustomerEntity {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? address;

  const CustomerEntity({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.address,
  });
}
