import 'package:flutter/material.dart';
import 'package:aura/features/telemetry/data/models/mqtt_config_model.dart';
import 'package:aura/features/telemetry/data/repositories/telemetry_repository.dart';
import 'package:aura/features/telemetry/data/services/mqtt_service.dart';

enum MqttUiStatus { disconnected, connecting, connected, error }

class TelemetryConnectionController extends ChangeNotifier {
  final TelemetryRepository _telemetryRepo;
  final MqttService _mqttService = MqttService.instance;

  TelemetryConnectionController(this._telemetryRepo) {
    _mqttService.connectionState.addListener(_updateStatusFromService);
    _updateStatusFromService();
  }

  MqttUiStatus uiStatus = MqttUiStatus.disconnected;
  String? errorMessage;
  MqttConfigModel? _cachedConfig;

  void _updateStatusFromService() {
    final state = _mqttService.connectionState.value;

    switch (state) {
      case MqttCurrentConnectionState.connected:
        uiStatus = MqttUiStatus.connected;
        break;
      case MqttCurrentConnectionState.connecting:
        uiStatus = MqttUiStatus.connecting;
        break;
      case MqttCurrentConnectionState.errorWhenConnecting:
        uiStatus = MqttUiStatus.error;
        break;
      default:
        uiStatus = MqttUiStatus.disconnected;
    }
    notifyListeners();
  }

  Future<void> toggleConnection() async {
    if (uiStatus == MqttUiStatus.connected || uiStatus == MqttUiStatus.connecting) {
      _disconnect();
    } else {
      await _connect();
    }
  }

  Future<void> _connect() async {
    uiStatus = MqttUiStatus.connecting;
    errorMessage = null;
    notifyListeners();

    try {
      _cachedConfig ??= await _telemetryRepo.getMqttSettings();
      final config = _cachedConfig!;

      if (config.host.trim().isEmpty) {
        throw Exception("Configuração de Host inválida/vazia.");
      }

      await _mqttService.connect(config);

      if (_mqttService.connectionState.value == MqttCurrentConnectionState.connected) {
        await _mqttService.subscribeToTopic(config.subscribeTopic);
      }
      
    } catch (e) {
      uiStatus = MqttUiStatus.error;
      errorMessage = "Erro: $e";
      notifyListeners();
    }
  }

  void _disconnect() {
    _mqttService.disconnect();
  }

  @override
  void dispose() {
    _mqttService.connectionState.removeListener(_updateStatusFromService);
    super.dispose();
  }
}