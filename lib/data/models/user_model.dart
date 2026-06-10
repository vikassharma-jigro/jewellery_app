import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String username;
  final String role;

  const UserModel({
    required this.id,
    required this.username,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'role': role,
    };
  }

  @override
  List<Object?> get props => [id, username, role];

  // Stub getters for legacy UI components
  String get name => username;
  String get emailOrPhone => "user@example.com";
  String? get avatarUrl => null;
}
