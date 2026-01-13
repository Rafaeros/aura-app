import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'package:aura/features/ble/data/dtos/ble_device_dto.dart';
import 'package:aura/features/ble/data/service/ble_service.dart';

class BleController extends ChangeNotifier {
  final BleService _bleService = BleService.instance;
  List<BluetoothDeviceDTO> scannedDevices = [];
  String? connectedDeviceId;
  String? connectingDeviceId;
  bool isScanning = false;
  String? errorMessage;
  StreamSubscription? _scanSubscription;
  StreamSubscription? _stateSubscription;
  StreamSubscription? _connectionStream;
  BleController() {
    _init();
  }
  void _init() {
    _scanSubscription = _bleService.scanResults.listen(
      (results) {
        scannedDevices = results.map((r) => BeaconParser.parse(r)).toList();
        scannedDevices.sort((a, b) => b.rssi.compareTo(a.rssi));
        notifyListeners();
      },
      onError: (e) {
        errorMessage = "Scan error: $e";
        notifyListeners();
      },
    );
    _stateSubscription = FlutterBluePlus.isScanning.listen((state) {
      isScanning = state;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    _stateSubscription?.cancel();
    _connectionStream?.cancel();
    super.dispose();
  }

  Future<void> startScan() async {
    errorMessage = null;
    scannedDevices.clear();
    notifyListeners();
    try {
      await _bleService.startScan();
    } catch (e) {
      errorMessage = "Scan start error: $e";
      notifyListeners();
    }
  }

  Future<void> stopScan() async => await _bleService.stopScan();
  Future<void> toggleConnection(BluetoothDevice device) async {
    if (connectedDeviceId == device.remoteId.str) {
      await disconnect(device);
    } else {
      await connect(device);
    }
  }

  Future<void> connect(BluetoothDevice device) async {
    connectingDeviceId = device.remoteId.str;
    notifyListeners();
    try {
      if (isScanning) await stopScan();
      await device.connect(
        autoConnect: false,
        timeout: const Duration(seconds: 10),
      );
      connectedDeviceId = device.remoteId.str;
      _connectionStream?.cancel();
      _connectionStream = device.connectionState.listen((state) {
        if (state == BluetoothConnectionState.disconnected) {
          connectedDeviceId = null;
          notifyListeners();
        }
      });
      final services = await device.discoverServices();
      final dto = scannedDevices.firstWhere((d) => d.device == device);
      dto.services = services;
      dto.isConnected = true;
      await device.requestMtu(256);
      notifyListeners();
    } catch (e) {
      errorMessage = "Fail to connect: $e";
    } finally {
      connectingDeviceId = null;
      notifyListeners();
    }
  }

  Future<void> disconnect(BluetoothDevice device) async {
    try {
      await device.disconnect();
    } catch (e) {
      errorMessage = "Fail to disconnect: $e";
    }
    final dto = scannedDevices.firstWhere((d) => d.device == device);
    dto.isConnected = false;
    dto.services = [];
    connectedDeviceId = null;
    notifyListeners();
  }

  bool isDeviceConnected(String id) => connectedDeviceId == id;
  bool isDeviceConnecting(String id) => connectingDeviceId == id;
  Future<List<BluetoothService>> discoverServices(
    BluetoothDevice device,
  ) async {
    try {
      return await device.discoverServices();
    } catch (e) {
      errorMessage = "Error discovering services: $e";
      notifyListeners();
      return [];
    }
  }

  Future<List<int>> readCharacteristic(BluetoothCharacteristic c) async {
    try {
      return await c.read();
    } catch (e) {
      errorMessage = "Error reading characteristic: $e";
      notifyListeners();
      return [];
    }
  }

  Future<void> setNotify(BluetoothCharacteristic c, bool enable) async {
    try {
      await c.setNotifyValue(enable);
    } catch (e) {
      errorMessage = "Error enabling notifications: $e";
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> readDeviceData(BluetoothDevice device) async {
    Map<String, dynamic> data = {};
    try {
      final services = await device.discoverServices();
      for (var service in services) {
        for (var c in service.characteristics) {
          final value = await c.read();
          data[c.uuid.toString()] = formatHex(value);
        }
      }
    } catch (e) {
      data["error"] = e.toString();
    }
    return data;
  }

  String formatHex(List<int> bytes) {
    return bytes
        .map((i) => i.toRadixString(16).padLeft(2, '0'))
        .join(' ')
        .toUpperCase();
  }
}
