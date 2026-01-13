class CompanySettingsModel {
  String everynetAccessToken;
  String mqttHost;
  int mqttPort;
  String mqttUsername;
  String? mqttPassword;

  CompanySettingsModel({
    required this.everynetAccessToken,
    required this.mqttHost,
    required this.mqttPort,
    required this.mqttUsername,
    this.mqttPassword,
  });

  factory CompanySettingsModel.fromJson(Map<String, dynamic> json) {
    return CompanySettingsModel(
      everynetAccessToken: json['everynet_access_token'],
      mqttHost: json['mqtt_host'],
      mqttPort: json['mqtt_port'],
      mqttUsername: json['mqtt_username'],
      mqttPassword: json['mqtt_password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'everynet_access_token': everynetAccessToken,
      'mqtt_host': mqttHost,
      'mqtt_port': mqttPort,
      'mqtt_username': mqttUsername,
      'mqtt_password': mqttPassword,
    };
  }
}
