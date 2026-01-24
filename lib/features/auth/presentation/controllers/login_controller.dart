import 'package:aura/core/routes/app_routes.dart';
import 'package:aura/core/services/local_storage_service.dart';
import 'package:aura/features/auth/data/models/auth_response_model.dart';
import 'package:aura/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

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

      if (response != null && response.token.isNotEmpty) {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(response.token);
        String roleFromToken = decodedToken['role']?.toString() ?? 'USER';

        await _storage.saveSecure(
          LocalStorageService.keyJwtToken,
          response.token,
        );
        await _storage.saveSecure(
          LocalStorageService.keyUserRole,
          roleFromToken,
        );
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

      if (role == 'OWNER' || role == 'ADMIN') {
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
