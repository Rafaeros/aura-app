class DeviceTag {
  final int? id;
  final int? deviceId;
  final String name;

  DeviceTag({this.id, required this.deviceId, required this.name});

  factory DeviceTag.fromJson(Map<String, dynamic> json) => DeviceTag(
    id: json['id'],
    deviceId: json['device_id'],
    name: json['name'] ?? '',
  );

  Map<String, dynamic> toJson() => {'device_id': deviceId, 'name': name};
}
