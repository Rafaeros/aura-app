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
      return PageResponse<DeviceModel>.fromJson(
        response.data,
        DeviceModel.fromJson,
      );
    } catch (e) {
      throw Exception("Erro ao buscar dispositivos paginados: $e");
    }
  }

  Future<DeviceModel> getDeviceByDeveui(String deveui) async {
    try {
      final response = await _apiService.getDeviceByDeveui(deveui);
      return DeviceModel.fromJson(response.data);
    } catch (e) {
      throw Exception("Error to get device by deveui: $e");
    }
  }

  Future<bool> existsByDevEui(String devEui) async {
    try {
      final response = await _apiService.existsByDevEui(devEui);
      return response.data as bool;
    } catch (e) {
      return false;
    }
  }

  Future<DeviceModel> getDeviceById(int id) async {
    final response = await _apiService.getDeviceById(id);
    return DeviceModel.fromJson(response.data);
  }

  Future<DeviceModel> createDevice(DeviceModel device) async {
    try {
      final response = await _apiService.createDevice(device.toJson());
      return DeviceModel.fromJson(response.data);
    } on DioException catch (e) {
      String errorMessage = "Failed to register device";

      if (e.response?.data != null && e.response!.data is Map) {
        final data = e.response!.data;

        if (data['validationErrors'] != null) {
          Map<String, dynamic> errors = data['validationErrors'];
          if (errors.isNotEmpty) errorMessage = errors.values.first.toString();
        } else if (data['message'] != null) {
          errorMessage = data['message'];
        }
      }

      throw AppException(
        message: errorMessage,
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
