import 'package:aura/features/devices/data/models/device_position.dart';
import 'package:aura/features/devices/data/models/device_tags.dart';
import 'package:aura/features/telemetry/data/models/device_telemetry_model.dart';

class DeviceModel {
  int? id;
  String? name;
  String? devEui;
  String? devAddr;
  String? appEui;
  String? nwksKey;
  String? appsKey;
  String? createdAt;
  String? updatedAt;
  List<DeviceTag>? tags;
  List<DevicePosition>? recentPositions;
  List<DeviceTelemetryModel>? recentLogs;

  DeviceModel({
    this.id,
    this.name,
    this.devEui,
    this.devAddr,
    this.appEui,
    this.nwksKey,
    this.appsKey,
    this.tags,
    this.recentPositions,
    this.recentLogs,
    this.createdAt,
    this.updatedAt,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'],
      name: json['name'],
      devEui: json['devEui'] ?? json['dev_eui'],
      devAddr: json['devAddr'] ?? json['dev_addr'],
      appEui: json['appEui'] ?? json['app_eui'],
      nwksKey: json['nwksKey'] ?? json['nwks_key'],
      appsKey: json['appsKey'] ?? json['apps_key'],

      tags:
          (json['tags'] as List?)?.map((i) => DeviceTag.fromJson(i)).toList() ??
          [],

      recentPositions:
          (json['recent_positions'] as List?)
              ?.map((i) => DevicePosition.fromJson(i))
              .toList() ??
          [],

      recentLogs:
          (json['recent_logs'] as List?)
              ?.map((i) => DeviceTelemetryModel.fromJson(i))
              .toList() ??
          [],

      createdAt: json['createdAt'] ?? json['created_at'],
      updatedAt: json['updatedAt'] ?? json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'dev_eui': devEui};
  }
}
