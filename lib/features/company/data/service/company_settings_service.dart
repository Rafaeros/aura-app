import 'package:dio/dio.dart';

class CompanySettingsApiService {
  final Dio _dio;

  CompanySettingsApiService(this._dio);

  Future<Response> saveMySettings(Map<String, dynamic> settings) async {
    return await _dio.put('/companies/current/settings', data: settings);
  }
}
