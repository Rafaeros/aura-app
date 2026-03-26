import 'package:flutter/foundation.dart';

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:aura/features/telemetry/data/models/mqtt_config_model.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

enum MqttCurrentConnectionState {
  idle,
  connecting,
  connected,
  disconnected,
  errorWhenConnecting,
}

enum MqttSubscriptionState { idle, subscribed }

class MqttService {
  MqttService._internal();
  static final MqttService instance = MqttService._internal();

  late MqttServerClient client;

  StreamSubscription? _updatesSubscription;

  final _messageStreamController = StreamController<String>.broadcast();
  Stream<String> get onMessage => _messageStreamController.stream;

  ValueNotifier<MqttSubscriptionState> subscriptionState = ValueNotifier(
    MqttSubscriptionState.idle,
  );

  ValueNotifier<MqttCurrentConnectionState> connectionState = ValueNotifier(
    MqttCurrentConnectionState.idle,
  );

  Future<void> connect(MqttConfigModel config) async {
    await _prepareMqttClient(config);
  }

  Future<void> _prepareMqttClient(MqttConfigModel config) async {
    await _setupMqttClient(config);
    await _connectClient(config);

    if (connectionState.value == MqttCurrentConnectionState.connected) {
      _publishMessage(config.publishTopic, '{"msg": "Hello from Aura APP"}');
    }
  }

  Future<void> _setupMqttClient(MqttConfigModel config) async {
    log("[MQTT] Configurando cliente: '${config.host}:${config.port}'");

    client = MqttServerClient.withPort(
      config.host.trim(),
      'aura_mobile_${DateTime.now().millisecondsSinceEpoch}',
      config.port,
    );

    client.secure = true;
    client.securityContext = SecurityContext.defaultContext;
    client.keepAlivePeriod = 20;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;
    client.onBadCertificate = (dynamic cert) => true;
  }

  Future<void> _connectClient(MqttConfigModel config) async {
    log("[MQTT] Conectando...");
    try {
      connectionState.value = MqttCurrentConnectionState.connecting;
      await client.connect(config.username.trim(), config.password.trim());
    } on Exception catch (e) {
      log("[MQTT] Erro ao conectar: $e");
      connectionState.value = MqttCurrentConnectionState.errorWhenConnecting;
      client.disconnect();
      return;
    }

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      log("[MQTT] Conectado!");
      connectionState.value = MqttCurrentConnectionState.connected;
    } else {
      connectionState.value = MqttCurrentConnectionState.errorWhenConnecting;
      client.disconnect();
    }
  }

  void _publishMessage(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    if (builder.payload == null) return;

    try {
      client.publishMessage(
        topic.trim(),
        MqttQos.atLeastOnce,
        builder.payload!,
      );
      log("📤 [MQTT] Mensagem publicada em $topic");
    } catch (e) {
      log("❌ [MQTT] Erro ao publicar: $e");
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    if (connectionState.value != MqttCurrentConnectionState.connected) return;

    log("[MQTT] Inscrevendo em: $topic");
    client.subscribe(topic.trim(), MqttQos.atLeastOnce);

    await _updatesSubscription?.cancel();

    _updatesSubscription = client.updates!.listen((events) {
      for (final event in events) {
        final recMess = event.payload as MqttPublishMessage;
        final topic = event.topic;
        final payload = MqttPublishPayload.bytesToStringAsString(
          recMess.payload.message,
        );

        log("📥 [MQTT Stream] Mensagem recebida de [$topic]. Repassando...");
        if (payload.length > 100) {
          log("📄 [MQTT Payload] ${payload.substring(0, 100)}...");
        } else {
          log("📄 [MQTT Payload] $payload");
        }

        _messageStreamController.add(payload);
      }
    });
  }

  void disconnect() {
    client.disconnect();
  }

  void dispose() {
    _messageStreamController.close();
    _updatesSubscription?.cancel();
  }

  void _onSubscribed(String topic) {
    log("[MQTT] Subscrito em $topic");
    subscriptionState.value = MqttSubscriptionState.subscribed;
  }

  void _onDisconnected() {
    log("[MQTT] Desconectado");
    connectionState.value = MqttCurrentConnectionState.disconnected;
  }

  void _onConnected() {
    connectionState.value = MqttCurrentConnectionState.connected;
  }
}
