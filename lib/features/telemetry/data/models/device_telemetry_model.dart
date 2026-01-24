import 'dart:convert';

class DeviceTelemetryModel {
  final int? id;
  final String? devEui;
  final String source;
  final String type;
  final Map<String, dynamic> payload;
  final String? createdAt;

  DeviceTelemetryModel({
    this.id,
    this.devEui,
    required this.source,
    required this.type,
    required this.payload,
    this.createdAt,
  });

  factory DeviceTelemetryModel.fromJson(Map<String, dynamic> json) {
    return DeviceTelemetryModel(
      id: json['id'] as int?,
      devEui: json['dev_eui'] as String? ?? json['devEui'] as String?,
      source: json['source'] as String? ?? 'UNKNOWN',
      type: json['type'] as String? ?? 'DATA',

      payload: _parseJsonField(json['payload']),

      createdAt: json['createdAt'] as String? ?? json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'source': source,
      'type': type,
      'payload': payload,
    };

    if (devEui != null) {
      data['dev_eui'] = devEui;
    }

    return data;
  }

  static Map<String, dynamic> _parseJsonField(dynamic value) {
    if (value == null) return {};
    if (value is Map) return Map<String, dynamic>.from(value);
    if (value is String) {
      try {
        return jsonDecode(value) as Map<String, dynamic>;
      } catch (_) {
        return {};
      }
    }
    return {};
  }
}
