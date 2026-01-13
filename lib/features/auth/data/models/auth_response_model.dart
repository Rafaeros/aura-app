class AuthResponseModel {
  final String token;
  final String username;
  final String email;
  final String role;
  final bool isSettingsConfigured;
  final bool isFirstAccess;

  AuthResponseModel({
    required this.token,
    required this.username,
    required this.email,
    required this.role,
    required this.isSettingsConfigured,
    required this.isFirstAccess,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      token: json['token'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'USER',
      isSettingsConfigured: json['is_settings_configured'] ?? false,
      isFirstAccess: json['is_first_access'] ?? false,
    );
  }
}
