import 'package:flutter/material.dart';

import 'package:aura/core/services/local_storage_service.dart';
import 'package:aura/features/auth/data/models/user_role_model.dart';
import 'package:aura/features/profile/data/model/user_profile_model.dart';
import 'package:aura/features/profile/data/repository/profile_repository.dart';

class ProfileController extends ChangeNotifier {
  final ProfileRepository _repository;
  final LocalStorageService _storage = LocalStorageService();

  UserProfileModel? user;

  bool isLoading = false;
  String? error;

  ProfileController(this._repository);

  Future<void> fetchUserProfile() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      UserProfileModel apiUser = await _repository.getCurrentUserProfile();
      final String? savedRoleString = await _storage.readSecure(
        LocalStorageService.keyUserRole,
      );
      final UserRole savedRole = UserRole.fromString(savedRoleString);
      UserRole finalRole = savedRole;
      if (apiUser.role != UserRole.USER && apiUser.role != savedRole) {
        finalRole = apiUser.role;
        await _storage.saveSecure(
          LocalStorageService.keyUserRole,
          finalRole.name,
        );
      }

      user = apiUser.copyWith(role: finalRole);
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
