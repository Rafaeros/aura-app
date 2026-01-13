import 'dart:math';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

enum DeviceType { classic, iBeacon, nordic, genericBeacon }

/// DTO representing a scanned Bluetooth device
/// Contains raw data and processed data (if it's a Beacon/Sensor)
class BluetoothDeviceDTO {
  final BluetoothDevice device;
  final int rssi;
  final DeviceType type;
  final bool isConnectable; // Defines whether to show the connect button
  bool isConnected = false;

  // Manufacturer Data (Raw manufacturer data)
  final Map<int, List<int>> manufacturerData;

  // Specific iBeacon data
  final String? beaconUuid;
  final int? major;
  final int? minor;
  final double? distance;

  // Specific Sensor Data (Nordic/Custom)
  final String? sensorMacId;
  final double? temperature;
  final String? rawPayloadString;

  // Service cache (populated AFTER connecting)
  List<BluetoothService> services = [];

  BluetoothDeviceDTO({
    required this.device,
    required this.rssi,
    required this.type,
    required this.isConnectable,
    this.manufacturerData = const {},
    this.beaconUuid,
    this.major,
    this.minor,
    this.distance,
    this.sensorMacId,
    this.temperature,
    this.rawPayloadString,
  });

  String get name =>
      device.platformName.isNotEmpty ? device.platformName : "Unknown Device";

  String get id => device.remoteId.str;
}

/// Class responsible for transforming a ScanResult into a rich DTO.
class BeaconParser {
  // Manufacturer IDs
  static const int appleCompanyId = 0x004C;
  static const int nordicCompanyId = 0x0059;

  static BluetoothDeviceDTO parse(ScanResult result) {
    final device = result.device;
    final rssi = result.rssi;
    final manufData = result.advertisementData.manufacturerData;

    // This flag is fundamental for knowing whether we display the connect button.
    final isConnectable = result.advertisementData.connectable;

    // 1. Try to parse iBeacon (Apple standard: manufacturer 0x004C)
    if (manufData.containsKey(appleCompanyId)) {
      final bytes = manufData[appleCompanyId]!;
      // Verify iBeacon header(0x02, 0x15) and length
      if (bytes.length >= 23 && bytes[0] == 0x02 && bytes[1] == 0x15) {
        return _createIBeaconDTO(device, rssi, bytes, manufData, isConnectable);
      }
    }

    // 2. Try to parse Nordic Sensor
    // You can only enter here if you are EXPLICITLY Nordic. (0x0059).
    if (manufData.containsKey(nordicCompanyId)) {
      final bytes = manufData[nordicCompanyId]!;
      return _createNordicDTO(device, rssi, bytes, manufData, isConnectable);
    }

    // 3. Generic beacon: has manufacturerData but is not iBeacon/Nordic
    if (manufData.isNotEmpty) {
      return _createGenericDTO(device, rssi, manufData, isConnectable);
    }

    // 4. Fallback: Bluetooth Classic / Generic
    // (Generic, headphones, etc)
    return BluetoothDeviceDTO(
      device: device,
      rssi: rssi,
      type: DeviceType.classic,
      isConnectable: isConnectable,
      manufacturerData: manufData,
      distance: _calculateDistance(rssi, 0),
    );
  }

  static BluetoothDeviceDTO _createIBeaconDTO(
    BluetoothDevice device,
    int rssi,
    List<int> bytes,
    Map<int, List<int>> manufData,
    bool isConnectable,
  ) {
    // iBeacon Format :
    // Byte 0-1: Header (0x0215)
    // Byte 2-17: UUID (16 bytes)
    final uuid = _formatUuid(bytes.sublist(2, 18));

    // Byte 18-19: Major
    final major = (bytes[18] << 8) + bytes[19];

    // Byte 20-21: Minor
    final minor = (bytes[20] << 8) + bytes[21];

    // Byte 22: Tx Power (Calibration)
    final txPower = bytes[22];

    final distance = _calculateDistance(rssi, txPower);

    return BluetoothDeviceDTO(
      device: device,
      rssi: rssi,
      type: DeviceType.iBeacon,
      isConnectable: isConnectable,
      manufacturerData: manufData,
      beaconUuid: uuid,
      major: major,
      minor: minor,
      distance: distance,
    );
  }

  static BluetoothDeviceDTO _createNordicDTO(
    BluetoothDevice device,
    int rssi,
    List<int> bytes,
    Map<int, List<int>> manufData,
    bool isConnectable,
  ) {
    String rawString = "";
    String? extractedMac;
    double? extractedTemp;

    try {
      rawString =
          String.fromCharCodes(bytes.where((b) => b >= 32 && b <= 126)).trim();
      final tempRegex = RegExp(r"T\s*[:=]\s*([0-9.]+)");
      final match = tempRegex.firstMatch(rawString);
      if (match != null) {
        extractedTemp = double.tryParse(match.group(1)!);
      }

      final macRegex = RegExp(r"([0-9A-F]{2}:){5}[0-9A-F]{2}");
      final macMatch = macRegex.firstMatch(rawString);
      if (macMatch != null) extractedMac = macMatch.group(0);
    } catch (e) {
      rawString = "Data error";
    }

    final distance = _calculateDistance(rssi, 0);

    return BluetoothDeviceDTO(
      device: device,
      rssi: rssi,
      type: DeviceType.nordic,
      isConnectable: isConnectable,
      manufacturerData: manufData,
      rawPayloadString: rawString,
      distance: distance,
      sensorMacId: extractedMac,
      temperature: extractedTemp,
    );
  }

  static BluetoothDeviceDTO _createGenericDTO(
    BluetoothDevice device,
    int rssi,
    Map<int, List<int>> manufData,
    bool isConnectable,
  ) {
    // Try decode as ASCII if any readable bytes exist
    final raw =
        manufData.values
            .expand((d) => d)
            .where((b) => b >= 32 && b <= 126)
            .map((b) => String.fromCharCode(b))
            .join();

    return BluetoothDeviceDTO(
      device: device,
      rssi: rssi,
      type: DeviceType.genericBeacon,
      isConnectable: isConnectable,
      manufacturerData: manufData,
      distance: _calculateDistance(rssi, 0),
      rawPayloadString: raw.isEmpty ? null : raw,
    );
  }

  static String _formatUuid(List<int> bytes) {
    String hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join('');
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}'
        .toUpperCase();
  }

  static double _calculateDistance(int rssi, int txPower) {
    if (rssi == 0) return -1.0;
    if (txPower != 0) {
      double ratio = rssi * 1.0 / txPower;
      if (ratio < 1.0) {
        return pow(ratio, 10).toDouble();
      } else {
        return (0.89976) * pow(ratio, 7.7095) + 0.111;
      }
    }

    const int rssiRef = -59;
    const double n = 2.2;

    return pow(10, (rssiRef - rssi) / (10 * n)).toDouble();
  }
}
