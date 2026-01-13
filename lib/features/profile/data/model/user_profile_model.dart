import 'package:aura/features/company/data/model/company_settings_model.dart';

class UserProfileModel {
  final String id;
  final String username;
  final String email;
  final CompanyModel? company;

  UserProfileModel({
    required this.id,
    required this.username,
    required this.email,
    this.company,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id']?.toString() ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      company:
          json['company'] != null
              ? CompanyModel.fromJson(json['company'])
              : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'company': company?.toJson(),
    };
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
}
