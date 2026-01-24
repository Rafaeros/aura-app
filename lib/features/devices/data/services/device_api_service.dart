import 'package:dio/dio.dart';

class DeviceApiService {
  final Dio _dio;

  DeviceApiService(this._dio);

  Future<Response> getAllDevices({int page = 0, int size = 10}) async {
    return await _dio.get(
      '/devices',
      queryParameters: {'page': page, 'size': size},
    );
  }

  Future<Response> getDeviceByDeveui(String deveui) async {
    return await _dio.get('/devices/dev-eui/$deveui');
  }

  Future<Response> existsByDevEui(String deveui) async {
    return await _dio.get('/devices/exists/$deveui');
  }

  Future<Response> getDeviceById(int id) async {
    return await _dio.get('/devices/$id');
  }

  Future<Response> createDevice(Map<String, dynamic> deviceData) async {
    return await _dio.post('/devices', data: deviceData);
  }

  Future<Response> deleteDevice(int id) async {
    return await _dio.delete('/devices/$id');
  }
}
