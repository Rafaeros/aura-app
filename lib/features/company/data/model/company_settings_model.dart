class CompanySettingsModel {
  String everynetAccessToken;
  String mqttHost;
  int mqttPort;
  String mqttUsername;
  String? mqttPassword;
  String? subscribeTopic;
  String? publishTopic;

  CompanySettingsModel({
    required this.everynetAccessToken,
    required this.mqttHost,
    required this.mqttPort,
    required this.mqttUsername,
    this.mqttPassword,
    this.subscribeTopic,
    this.publishTopic,
  });

  factory CompanySettingsModel.fromJson(Map<String, dynamic> json) {
    return CompanySettingsModel(
      everynetAccessToken: json['everynetAccessToken'] ?? json['everynet_access_token'] ?? '',
      mqttHost: json['mqttHost'] ?? json['mqtt_host'] ?? '',
      mqttPort: json['mqttPort'] ?? json['mqtt_port'] ?? 1883,
      mqttUsername: json['mqttUsername'] ?? json['mqtt_username'] ?? '',
      mqttPassword: json['mqttPassword'] ?? json['mqtt_password'],
      subscribeTopic: json['subscribeTopic'] ?? json['subscribe_topic'],
      publishTopic: json['publishTopic'] ?? json['publish_topic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'everynetAccessToken': everynetAccessToken,
      'mqttHost': mqttHost,
      'mqttPort': mqttPort,
      'mqttUsername': mqttUsername,
      'mqttPassword': mqttPassword,
      'subscribeTopic': subscribeTopic,
      'publishTopic': publishTopic,
    };
  }
}
