import 'package:dio/dio.dart';

class AuthApiService {
  final Dio _dio;

  AuthApiService(this._dio);

  Future<Response> login(String email, String password) async {
    return await _dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
  }

  Future<Response> activateAccount(
    String email,
    String tempPassword,
    String newPassword,
    String confirmNewPassword,
  ) async {
    return await _dio.post(
      '/auth/activate-account',
      data: {
        'email': email,
        'temp_password': tempPassword,
        'new_password': newPassword,
        'confirm_new_password': confirmNewPassword,
      },
    );
  }
}
