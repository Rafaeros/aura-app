import '../models/device_model.dart';
import '../services/device_api_service.dart';

class DeviceRepository {
  final DeviceApiService _apiService;

  DeviceRepository(this._apiService);

  Future<List<DeviceModel>> getDevices() async {
    final response = await _apiService.getAllDevices();
    return (response.data as List)
        .map((json) => DeviceModel.fromJson(json))
        .toList();
  }

  Future<DeviceModel> getDeviceById(int id) async {
    final response = await _apiService.getDeviceById(id);
    return DeviceModel.fromJson(response.data);
  }

  Future<DeviceModel> createDevice(DeviceModel device) async {
    try {
      final response = await _apiService.createDevice(device.toJson());
      return DeviceModel.fromJson(response.data);
    } catch (e) {
      throw Exception("Error to create device: $e");
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
