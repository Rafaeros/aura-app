import 'package:aura/features/auth/data/models/user_role_model.dart';
import 'package:aura/features/company/data/model/company_settings_model.dart';

class UserProfileModel {
  final String id;
  final String username;
  final String email;
  final CompanyModel? company;
  final UserRole role;

  UserProfileModel({
    required this.id,
    required this.username,
    required this.email,
    this.company,
    this.role = UserRole.USER,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    var company = json['company'] != null ? CompanyModel.fromJson(json['company']) : null;
    
    // settings is returned at the root of the `/me` API response
    if (company != null && json['settings'] != null) {
      company = company.copyWith(settings: CompanySettingsModel.fromJson(json['settings']));
    }

    return UserProfileModel(
      id: json['id']?.toString() ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      company: company,
      role: UserRole.fromString(json['role']?.toString()),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'company': company?.toJson(),
      'role': role.name,
    };
  }

  UserProfileModel copyWith({
    String? id,
    String? username,
    String? email,
    CompanyModel? company,
    UserRole? role,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      company: company ?? this.company,
      role: role ?? this.role,
    );
  }
}

class CompanyModel {
  final String id;
  final String name;
  final String cnpj;
  final CompanySettingsModel? settings;

  CompanyModel({
    required this.id,
    required this.name,
    required this.cnpj,
    this.settings,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      cnpj: json['cnpj'] ?? '',

      settings:
          json['settings'] != null
              ? CompanySettingsModel.fromJson(json['settings'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cnpj': cnpj,
      'settings': settings?.toJson(),
    };
  }

  CompanyModel copyWith({
    String? id,
    String? name,
    String? cnpj,
    CompanySettingsModel? settings,
  }) {
    return CompanyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      cnpj: cnpj ?? this.cnpj,
      settings: settings ?? this.settings,
    );
  }
}
