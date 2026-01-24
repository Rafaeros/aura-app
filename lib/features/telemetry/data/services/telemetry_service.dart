import 'package:dio/dio.dart';

class TelemetryApiService {
  final Dio _dio;

  TelemetryApiService(this._dio);

  Future<Response> saveTelemetry(Map<String, dynamic> data) async {
    return await _dio.post('/devices/telemetry', data: data);
  }

  Future<Response> getMqttSettings() async {
    return await _dio.get('/companies/current/settings/mqtt');
  }

  Future<Response> getTelemetriesByDeviceId({
    required int deviceId,
    required int page,
    required int size,
  }) async {
    return await _dio.get(
      '/devices/$deviceId/telemetry',
      queryParameters: {
        'page': page,
        'size': size,
        'sort': 'createdAt,desc',
      },
    );
  }
}