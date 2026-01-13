import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math' hide log;

import 'package:flutter/foundation.dart';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

enum MqttConnectionStatus { disconnected, connecting, connected, error }

class MqttService {
  MqttService._internal();
  static final MqttService instance = MqttService._internal();

  MqttServerClient? _client;

  final _messageController = StreamController<String>.broadcast();
  Stream<String> get messageStream => _messageController.stream;

  final ValueNotifier<MqttConnectionStatus> statusNotifier = ValueNotifier(
    MqttConnectionStatus.disconnected,
  );

  bool get isConnected =>
      _client?.connectionStatus?.state == MqttConnectionState.connected;

  Future<void> connect({
    required String host,
    required int port,
    required String user,
    required String password,
  }) async {
    if (isConnected) {
      log("⚠️ [MQTT Core] Já conectado. Ignorando solicitação.");
      return;
    }

    if (host.isEmpty) {
      statusNotifier.value = MqttConnectionStatus.error;
      log("❌ [MQTT Core] Host vazio.");
      return;
    }

    statusNotifier.value = MqttConnectionStatus.connecting;
    final clientIdentifier = 'aura_mobile_${Random().nextInt(10000)}';

    log(
      "🔌 [MQTT Core] Iniciando conexão em $host:$port como $clientIdentifier...",
    );

    _client = MqttServerClient.withPort(host, clientIdentifier, port);
    _client!.logging(on: false);
    _client!.keepAlivePeriod = 60;
    _client!.onDisconnected = _onDisconnected;
    _client!.onConnected = _onConnected;
    _client!.onSubscribed = _onSubscribed;
    _client!.secure = true;
    _client!.securityContext = SecurityContext.defaultContext;
    final connMess = MqttConnectMessage()
        .withClientIdentifier(clientIdentifier)
        .withWillTopic('aura/status')
        .withWillMessage('Mobile Disconnected')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    _client!.connectionMessage = connMess;

    try {
      await _client!.connect(user, password);
    } on Exception catch (e) {
      log("❌ [MQTT Core] Exceção na conexão: $e");
      _disconnectCleanup();
      statusNotifier.value = MqttConnectionStatus.error;
    } catch (e) {
      log("❌ [MQTT Core] Erro desconhecido: $e");
      _disconnectCleanup();
      statusNotifier.value = MqttConnectionStatus.error;
    }
    if (_client?.connectionStatus?.state != MqttConnectionState.connected) {
      log("❌ [MQTT Core] Falha: Status final não é conectado.");
      _disconnectCleanup();
      statusNotifier.value = MqttConnectionStatus.error;
    }
  }

  void disconnect() {
    log("🛑 [MQTT Core] Solicitando desconexão...");
    _client?.disconnect();
  }

  void subscribe(String topic) {
    if (!isConnected) {
      log("⚠️ [MQTT Core] Tentativa de subscribe sem conexão.");
      return;
    }

    log("📡 [MQTT Core] Inscrevendo em: $topic");
    _client!.subscribe(topic, MqttQos.atLeastOnce);
    _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final payload = MqttPublishPayload.bytesToStringAsString(
        recMess.payload.message,
      );
      _messageController.add(payload);
    });
  }

  void publish(String topic, String message) {
    if (!isConnected) {
      log("⚠️ [MQTT Core] Não conectado. Não foi possível publicar.");
      return;
    }

    final builder = MqttClientPayloadBuilder();
    builder.addString(message);

    if (builder.payload != null) {
      _client!.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
      log("📤 [MQTT Core] Enviado para $topic: $message");
    }
  }

  void _onConnected() {
    log("✅ [MQTT Core] CONECTADO COM SUCESSO!");
    statusNotifier.value = MqttConnectionStatus.connected;
  }

  void _onDisconnected() {
    log("⚠️ [MQTT Core] Desconectado.");
    statusNotifier.value = MqttConnectionStatus.disconnected;
    _disconnectCleanup();
  }

  void _onSubscribed(String topic) {
    log("✅ [MQTT Core] Inscrição confirmada no tópico: $topic");
  }

  void _disconnectCleanup() {}

  void dispose() {
    _messageController.close();
    _client?.disconnect();
  }
}
