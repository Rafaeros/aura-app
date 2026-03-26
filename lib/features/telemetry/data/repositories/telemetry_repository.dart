import 'package:aura/core/client/api_response.dart';
import 'package:aura/core/client/model/page_response.dart';
import 'package:aura/features/telemetry/data/models/device_telemetry_model.dart';
import 'package:aura/features/telemetry/data/models/mqtt_config_model.dart';
import 'package:aura/features/telemetry/data/services/telemetry_service.dart';

class TelemetryRepository {
  final TelemetryApiService _apiService;
  TelemetryRepository(this._apiService);

  Future<void> saveTelemetry(DeviceTelemetryModel telemetry) async {
    try {
      await _apiService.saveTelemetry(telemetry.toJson());
    } catch (e) {
      throw Exception("Erro ao salvar telemetria: $e");
    }
  }

  Future<MqttConfigModel> getMqttSettings() async {
    try {
      final response = await _apiService.getMqttSettings();
      final apiResponse = ApiResponse<MqttConfigModel>.fromJson(
        response.data,
        (json) => MqttConfigModel.fromJson(json as Map<String, dynamic>),
      );
      return apiResponse.data!;
    } catch (e) {
      throw Exception('Erro ao buscar configurações MQTT: $e');
    }
  }

  Future<PageResponse<DeviceTelemetryModel>> getTelemetriesByDeviceId({
    required int deviceId,
    required int page,
    required int size,
  }) async {
    try {
      final response = await _apiService.getTelemetriesByDeviceId(
        deviceId: deviceId,
        page: page,
        size: size,
      );

      final apiResponse = ApiResponse<PageResponse<DeviceTelemetryModel>>.fromJson(
        response.data,
        (json) => PageResponse<DeviceTelemetryModel>.fromJson(
          json as Map<String, dynamic>,
          DeviceTelemetryModel.fromJson,
        ),
      );
      return apiResponse.data!;
    } catch (e) {
      throw Exception("Erro ao buscar histórico de telemetria: $e");
    }
  }
}
