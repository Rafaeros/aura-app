// ignore_for_file: constant_identifier_names
enum UserRole {
  ADMIN,
  OWNER,
  USER;

  static UserRole fromString(String? value) {
    return UserRole.values.firstWhere(
      (e) => e.name == (value?.toUpperCase()),
      orElse: () => UserRole.USER,
    );
  }
}

extension RoleCapabilities on UserRole {
  bool get canViewSensitiveData {
    return this == UserRole.ADMIN || this == UserRole.OWNER;
  }

  bool get canEditCompanySettings {
    return this == UserRole.ADMIN || this == UserRole.OWNER;
  }

  bool get canManageUsers {
    return this == UserRole.ADMIN;
  }
}
