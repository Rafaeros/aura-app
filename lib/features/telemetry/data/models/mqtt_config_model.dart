class MqttConfigModel {
  final String host;
  final int port;
  final String username;
  final String password;
  final String subscribeTopic;
  final String publishTopic;

  MqttConfigModel({
    required this.host,
    required this.port,
    required this.username,
    required this.password,
    required this.subscribeTopic,
    required this.publishTopic,
  });

  factory MqttConfigModel.fromJson(Map<String, dynamic> json) {
    return MqttConfigModel(
      host: (json['mqttHost'] ?? json['mqtt_host'] ?? '')
          .toString()
          .trim()
          .replaceAll('mqtts://', '')
          .replaceAll('mqtt://', ''),
      port: json['mqttPort'] ?? json['mqtt_port'] ?? 8883,
      username:
          (json['mqttUsername'] ?? json['mqtt_username'] ?? '')
              .toString()
              .trim(),
      password:
          (json['mqttPassword'] ?? json['mqtt_password'] ?? '')
              .toString()
              .trim(),
      subscribeTopic:
          (json['subscribeTopic'] ?? json['subscribe_topic'] ?? '')
              .toString()
              .trim(),
      publishTopic:
          (json['publishTopic'] ?? json['publish_topic'] ?? '')
              .toString()
              .trim(),
    );
  }
}
