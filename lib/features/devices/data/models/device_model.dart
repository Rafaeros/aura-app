import 'package:aura/features/devices/data/models/device_position.dart';
import 'package:aura/features/devices/data/models/device_tags.dart';

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
  List<DevicePosition>? positions;

  DeviceModel({
    this.id,
    this.name,
    this.devEui,
    this.devAddr,
    this.appEui,
    this.nwksKey,
    this.appsKey,
    this.tags,
    this.positions,
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
          json['tags'] != null
              ? (json['tags'] as List)
                  .map((i) => DeviceTag.fromJson(i))
                  .toList()
              : [],
      positions:
          json['positions'] != null
              ? (json['positions'] as List)
                  .map((i) => DevicePosition.fromJson(i))
                  .toList()
              : [],
      createdAt: json['createdAt'] ?? json['created_at'],
      updatedAt: json['updatedAt'] ?? json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'dev_eui': devEui};
  }
}
