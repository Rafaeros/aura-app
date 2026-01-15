import 'package:aura/core/routes/app_routes.dart';
import 'package:aura/core/services/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SplashController extends ChangeNotifier {
  final LocalStorageService _storage = LocalStorageService();

  Future<String> checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 3));

    try {
      final isFirstRun = await _storage.readBool(
        LocalStorageService.keyIsFirstRun,
      );

      if (isFirstRun == null || isFirstRun) {
        return AppRoutes.welcome;
      }

      final token = await _storage.readSecure(LocalStorageService.keyJwtToken);
      final role = await _storage.readSecure(LocalStorageService.keyUserRole);

      if (token == null || token.isEmpty) {
        return AppRoutes.login;
      }

      if (JwtDecoder.isExpired(token)) {
        await _storage.clearAllSecure();
        return AppRoutes.login;
      }

      if (role == 'OWNER') {
        return AppRoutes.home;
      } else {
        return AppRoutes.home;
      }
    } catch (e) {
      await _storage.clearAllSecure();
      return AppRoutes.login;
    }
  }
}
