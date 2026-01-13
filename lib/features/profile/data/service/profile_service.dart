import 'package:dio/dio.dart';

class ProfileApiService {
  final Dio _dio;

  ProfileApiService(this._dio);

  Future<Response> findCurrentUserProfile() async {
    return await _dio.get('/users/me');
  }
}
