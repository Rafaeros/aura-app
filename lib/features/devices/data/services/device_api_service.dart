import 'package:dio/dio.dart';

class DeviceApiService {
  final Dio _dio;

  DeviceApiService(this._dio);

  Future<Response> getAllDevices() async {
    return await _dio.get('/devices');
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
