import 'package:aura/features/profile/data/model/user_profile_model.dart';
import 'package:aura/features/profile/data/repository/profile_repository.dart';
import 'package:flutter/material.dart';

class ProfileController extends ChangeNotifier {
  final ProfileRepository _repository;

  UserProfileModel? user;
  bool isLoading = false;
  String? error;

  ProfileController(this._repository);

  Future<void> fetchUserProfile() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      user = await _repository.getCurrentUserProfile();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
