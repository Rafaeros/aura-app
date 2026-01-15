import 'package:flutter/foundation.dart';

import 'package:aura/core/routes/app_routes.dart';
import 'package:aura/core/services/local_storage_service.dart';
import 'package:aura/features/auth/data/models/auth_response_model.dart';
import 'package:aura/features/auth/data/repositories/auth_repository.dart';

class LoginController extends ChangeNotifier {
  final AuthRepository repository;
  bool isLoading = false;
  String? _currentUserRole;
  final LocalStorageService _storage = LocalStorageService();

  LoginController(this.repository);

  Future<AuthResponseModel?> signIn(String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      final AuthResponseModel? response = await repository.login(
        email,
        password,
      );

      if (response != null) {
        if (response.token.isNotEmpty) {
          await _storage.saveSecure(
            LocalStorageService.keyJwtToken,
            response.token,
          );
        }
        await _storage.saveSecure(
          LocalStorageService.keyUserRole,
          response.role,
        );

        _currentUserRole = response.role;
      }

      return response;
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> activateAccount(
    String email,
    String tempPassword,
    String newPassword,
    String confirmNewPassword,
  ) async {
    isLoading = true;
    notifyListeners();
    try {
      await repository.activateAccount(
        email,
        tempPassword,
        newPassword,
        confirmNewPassword,
      );

      String role = _currentUserRole ?? '';
      if (role.isEmpty) {
        role = await _storage.readSecure('user_role') ?? '';
      }

      if (role == 'OWNER') {
        return AppRoutes.companySetup;
      } else {
        return AppRoutes.home;
      }
    } catch (e) {
      debugPrint("Error in activate account: $e");
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
