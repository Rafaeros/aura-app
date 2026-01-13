import 'package:aura/features/auth/data/models/company_model.dart';

class UserModel {
  final int id;
  final String username;
  final String email;
  final String role;
  final CompanyModel company;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.company,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      role: json['role'],
      company: CompanyModel.fromJson(json['company']),
    );
  }
}
