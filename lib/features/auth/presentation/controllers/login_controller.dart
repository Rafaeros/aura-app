import 'package:aura/core/routes/app_routes.dart';
import 'package:aura/features/auth/data/models/auth_response_model.dart';
import 'package:flutter/foundation.dart';
import 'package:aura/features/auth/data/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends ChangeNotifier {
  final AuthRepository repository;
  bool isLoading = false;
  String? _currentUserRole;

  LoginController(this.repository);

  Future<AuthResponseModel?> signIn(String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      final AuthResponseModel? response = await repository.login(email, password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', response?.token ?? '');
      
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
        final prefs = await SharedPreferences.getInstance();
        role = prefs.getString('user_role') ?? '';
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
