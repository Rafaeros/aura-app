import 'package:dio/dio.dart';

import 'package:aura/core/client/api_response.dart';
import 'package:aura/core/exception/app_exception.dart';
import 'package:aura/features/auth/data/models/auth_response_model.dart';
import 'package:aura/features/auth/data/services/auth_api_service.dart';

class AuthRepository {
  final AuthApiService _apiService;
  AuthRepository(this._apiService);

  Future<AuthResponseModel?> login(String email, String password) async {
    try {
      final response = await _apiService.login(email, password);
      final apiResponse = ApiResponse<AuthResponseModel>.fromJson(
        response.data,
        (json) => AuthResponseModel.fromJson(json as Map<String, dynamic>),
      );
      return apiResponse.data;
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error as AppException;
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
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error as AppException;
      }
      throw AppException(
        message: 'Failed to connect to the server.',
        severity: ErrorSeverity.ERROR,
      );
    } catch (e) {
      rethrow;
    }
  }
}
