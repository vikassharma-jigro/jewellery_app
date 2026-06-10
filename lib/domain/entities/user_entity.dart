class UserEntity {
  final String id;
  final String name;
  final String emailOrPhone;
  final String role;
  final String? avatarUrl;

  const UserEntity({
    required this.id,
    required this.name,
    required this.emailOrPhone,
    required this.role,
    this.avatarUrl,
  });
}
