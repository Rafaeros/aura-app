import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleService {
  BleService._internal();
  static final BleService instance = BleService._internal();
  factory BleService() => instance;

  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;

  Stream<BluetoothAdapterState> get adapterState =>
      FlutterBluePlus.adapterState;

  bool get isScanning => FlutterBluePlus.isScanningNow;

  Future<void> init() async {
    FlutterBluePlus.setLogLevel(LogLevel.info, color: true);
  }

  Future<void> startScan() async {
    if (FlutterBluePlus.adapterStateNow != BluetoothAdapterState.on) {
      log("[BLE] Adapter is off. Waiting for it to turn on...");

      try {
        await FlutterBluePlus.adapterState
            .where((s) => s == BluetoothAdapterState.on)
            .first
            .timeout(const Duration(seconds: 3));
      } catch (_) {
        log("[BLE] Timeout: Bluetooth is still off.");

        if (Platform.isAndroid) {
          try {
            await FlutterBluePlus.turnOn();
          } catch (_) {
            throw Exception("Bluetooth is off. Please enable it in settings.");
          }
        } else {
          throw Exception("Bluetooth is off. Please enable it in settings.");
        }
      }
    }

    if (isScanning) {
      log("[BLE] startScan called, but scan is already running.");
      return;
    }

    log("[BLE] Starting BLE scan...");

    try {
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 15),
        androidUsesFineLocation: true,
      );
    } catch (e) {
      log("[BLE] Error while starting scan: $e");
      throw Exception("Error starting scan.");
    }
  }

  Future<void> stopScan() async {
    if (!isScanning) {
      log("[BLE] stopScan called, but scan is not active.");
      return;
    }

    log("[BLE] Stopping BLE scan...");
    await FlutterBluePlus.stopScan();
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    log(
      "[BLE] Connecting to device: ${device.platformName} (${device.remoteId})",
    );
    if (isScanning) await stopScan();

    await device.connect(timeout: const Duration(seconds: 15));
    if (Platform.isAndroid) {
      try {
        await device.requestMtu(517);
        log("[BLE] MTU request successful.");
      } catch (e) {
        log("[BLE] MTU request failed: $e");
      }
    }

    var services = await device.discoverServices();
    if (Platform.isAndroid && services.isEmpty) {
      log("[BLE] No services found, retrying discovery...");
      try {
        await device.createBond();
        await Future.delayed(const Duration(seconds: 2));
        await device.discoverServices();
      } catch (e) {
        log("[BLE] Bonding failed: $e");
      }
    }

    log("[BLE] Discovered ${services.length} services.");
  }

  Future<void> disconnectDevice(BluetoothDevice device) async {
    log(
      "[BLE] Disconnecting from device: ${device.platformName} (${device.remoteId})",
    );
    await device.disconnect();
  }
}
