import 'package:aura/core/client/api_response.dart';
import 'package:aura/core/client/model/page_response.dart';
import 'package:aura/core/exception/app_exception.dart';
import 'package:aura/features/devices/data/models/device_model.dart';
import 'package:aura/features/devices/data/services/device_api_service.dart';
import 'package:dio/dio.dart';

class DeviceRepository {
  final DeviceApiService _apiService;

  DeviceRepository(this._apiService);

  Future<PageResponse<DeviceModel>> getDevices({
    int page = 0,
    int size = 10,
  }) async {
    try {
      final response = await _apiService.getAllDevices(page: page, size: size);
      final apiResponse = ApiResponse<PageResponse<DeviceModel>>.fromJson(
        response.data,
        (json) => PageResponse<DeviceModel>.fromJson(
          json as Map<String, dynamic>,
          DeviceModel.fromJson,
        ),
      );
      return apiResponse.data!;
    } catch (e) {
      throw Exception("Erro ao buscar dispositivos paginados: $e");
    }
  }

  Future<DeviceModel> getDeviceByDeveui(String deveui) async {
    try {
      final response = await _apiService.getDeviceByDeveui(deveui);
      final apiResponse = ApiResponse<DeviceModel>.fromJson(
        response.data,
        (json) => DeviceModel.fromJson(json as Map<String, dynamic>),
      );
      return apiResponse.data!;
    } catch (e) {
      throw Exception("Error to get device by deveui: $e");
    }
  }

  Future<bool> existsByDevEui(String devEui) async {
    try {
      final response = await _apiService.existsByDevEui(devEui);
      final apiResponse = ApiResponse<bool>.fromJson(
        response.data,
        (json) => json as bool,
      );
      return apiResponse.data ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<DeviceModel> getDeviceById(int id) async {
    final response = await _apiService.getDeviceById(id);
    final apiResponse = ApiResponse<DeviceModel>.fromJson(
      response.data,
      (json) => DeviceModel.fromJson(json as Map<String, dynamic>),
    );
    return apiResponse.data!;
  }

  Future<DeviceModel> createDevice(DeviceModel device) async {
    try {
      final response = await _apiService.createDevice(device.toJson());
      final apiResponse = ApiResponse<DeviceModel>.fromJson(
        response.data,
        (json) => DeviceModel.fromJson(json as Map<String, dynamic>),
      );
      return apiResponse.data!;
    } on DioException catch (e) {
      if (e.error is AppException) throw e.error as AppException;
      
      throw AppException(
        message: "Failed to register device. ${e.message}",
        severity: ErrorSeverity.WARNING,
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw AppException(
        message: "Unexpected error: $e",
        severity: ErrorSeverity.ERROR,
      );
    }
  }

  Future<void> deleteDevice(int id) async {
    try {
      await _apiService.deleteDevice(id);
    } catch (e) {
      throw Exception("Error to delete device: $e");
    }
  }
}
