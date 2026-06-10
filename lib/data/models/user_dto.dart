import '../../domain/entities/user_entity.dart';

class UserDto {
  final String id;
  final String name;
  final String emailOrPhone;
  final String role;
  final String? avatarUrl;

  UserDto({
    required this.id,
    required this.name,
    required this.emailOrPhone,
    required this.role,
    this.avatarUrl,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name'] ?? '',
      emailOrPhone: json['emailOrPhone'] ?? json['email'] ?? json['phone'] ?? '',
      role: json['role'] ?? 'user',
      avatarUrl: json['avatarUrl'],
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      emailOrPhone: emailOrPhone,
      role: role,
      avatarUrl: avatarUrl,
    );
  }
}
