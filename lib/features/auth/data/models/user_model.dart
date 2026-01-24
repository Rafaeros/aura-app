import 'package:aura/features/auth/data/models/company_model.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserModel {
  final int id;
  final String username;
  final String email;
  final String role;
  final CompanyModel company;
  final String? token;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.company,
    this.token,
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

  factory UserModel.fromToken(String token) {
    Map<String, dynamic> payload = JwtDecoder.decode(token);
    return UserModel(
      id: payload['id'] ?? 0,
      username: payload['username'] ?? payload['username'] ?? 'User',
      email: payload['email'] ?? payload['sub'] ?? '',
      role: payload['role'] ?? 'USER',
      company: CompanyModel(id: payload['companyId'] ?? 0, name: '', cnpj: ''),
      token: token,
    );
  }
}
