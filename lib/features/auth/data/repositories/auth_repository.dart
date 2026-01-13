import 'package:dio/dio.dart';

import 'package:aura/core/exception/app_exception.dart';
import 'package:aura/features/auth/data/models/auth_response_model.dart';
import 'package:aura/features/auth/data/services/auth_api_service.dart';

class AuthRepository {
  final AuthApiService _apiService;
  AuthRepository(this._apiService);

  Future<AuthResponseModel?> login(String email, String password) async {
    try {
      final response = await _apiService.login(email, password);
      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null) {
        throw AppException.fromJson(
          e.response!.data,
          e.response!.statusCode ?? 0,
        );
      }
      throw AppException(
        message: 'Failed to connect to the server.',
        severity: ErrorSeverity.ERROR,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> activateAccount(
    String email,
    String tempPassword,
    String newPassword,
    String confirmNewPassword,
  ) async {
    try {
      await _apiService.activateAccount(
        email,
        tempPassword,
        newPassword,
        confirmNewPassword,
      );
    } catch (e) {
      rethrow;
    }
  }
}
