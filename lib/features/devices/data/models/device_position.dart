class DevicePosition {
  final int? id;
  final int? deviceId;
  final double latitude;
  final double longitude;
  final DateTime? createdAt;

  DevicePosition({
    this.id,
    this.deviceId,
    required this.latitude,
    required this.longitude,
    this.createdAt,
  });

  factory DevicePosition.fromJson(Map<String, dynamic> json) {
    return DevicePosition(
      id: json['id'],
      deviceId: json['device_id'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      createdAt:
          json['created_at'] != null
              ? DateTime.tryParse(json['created_at'])
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'device_id': deviceId,
    'latitude': latitude,
    'longitude': longitude,
    'created_at': createdAt?.toIso8601String(),
  };
}
