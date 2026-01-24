import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:aura/features/devices/data/repository/device_repository.dart';
import 'package:aura/features/telemetry/data/models/device_telemetry_model.dart';
import 'package:aura/features/telemetry/data/repositories/telemetry_repository.dart';
import 'package:aura/features/telemetry/data/services/mqtt_service.dart';

class TelemetrySyncController {
  final MqttService _mqttService;
  final DeviceRepository _deviceRepo;
  final TelemetryRepository _telemetryRepo;

  StreamSubscription? _subscription;

  TelemetrySyncController(
    this._mqttService,
    this._deviceRepo,
    this._telemetryRepo,
  ) {
    _startListening();
  }

  void _startListening() {
    log("[SyncController] 🟢 Serviço de Sincronização Iniciado");
    _subscription = _mqttService.onMessage.listen((payload) async {
      await _processMessage(payload);
    });
  }

  Future<void> _processMessage(String payload) async {
    try {
      final Map<String, dynamic> json = jsonDecode(payload);
      final String? devEui = json['meta']?['device'];

      if (devEui == null) {
        log("⚠️ [Sync] Ignorado: Payload sem 'meta.device'");
        return;
      }

      final exists = await _deviceRepo.existsByDevEui(devEui);

      if (!exists) {
        log("👻 [Sync] Ignorado: Dispositivo $devEui não cadastrado.");
        return;
      }

      log("🔄 [Sync] Processando dados para $devEui...");

      final telemetry = DeviceTelemetryModel(
        id: null,
        devEui: devEui,
        source: 'LORAWAN_EVERYNET',
        type: (json['type'] as String?)?.toUpperCase() ?? 'DATA',
        payload: json,

        createdAt: DateTime.now().toUtc().toIso8601String(),
      );

      await _telemetryRepo.saveTelemetry(telemetry);
      log("✅ [Sync] Salvo com sucesso no banco.");
    } catch (e, s) {
      log("❌ [Sync] Erro ao processar mensagem: $e", error: e, stackTrace: s);
    }
  }

  void dispose() {
    _subscription?.cancel();
    log("[SyncController] 🔴 Serviço de Sincronização Parado");
  }
}
