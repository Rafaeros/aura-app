import 'package:aura/core/presentation/theme/app_colors.dart';
import 'package:aura/features/ble/data/dtos/ble_device_dto.dart';
import 'package:aura/features/ble/presentation/controllers/ble_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BleDeviceCard extends StatelessWidget {
  final BluetoothDeviceDTO deviceDto;

  const BleDeviceCard({super.key, required this.deviceDto});

  @override
  Widget build(BuildContext context) {
    final isBeaconOrSensor = deviceDto.type != DeviceType.classic;
    final accentColor =
        isBeaconOrSensor ? AppColors.primary : AppColors.textSecondary;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isBeaconOrSensor ? Icons.sensors : Icons.bluetooth,
              color: accentColor,
              size: 24,
            ),
          ),
          title: Text(
            deviceDto.name.isNotEmpty ? deviceDto.name : "Unknown Device",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontSize: 15,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Row(
              children: [
                _buildRssiIndicator(deviceDto.rssi),
                const SizedBox(width: 12),
                if (deviceDto.distance != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "${deviceDto.distance?.toStringAsFixed(1)}m",
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          trailing: _buildTrailingAction(context, deviceDto),
          children: [_buildDetailContent(deviceDto)],
        ),
      ),
    );
  }

  Widget _buildRssiIndicator(int rssi) {
    Color signalColor;
    IconData signalIcon;

    if (rssi >= -60) {
      signalColor = Colors.greenAccent;
      signalIcon = Icons.signal_cellular_alt_rounded;
    } else if (rssi >= -80) {
      signalColor = Colors.amberAccent;
      signalIcon = Icons.signal_cellular_alt_2_bar_rounded;
    } else {
      signalColor = Colors.redAccent;
      signalIcon = Icons.signal_cellular_alt_1_bar_rounded;
    }

    return Row(
      children: [
        Icon(signalIcon, size: 14, color: signalColor),
        const SizedBox(width: 4),
        Text(
          "$rssi dBm",
          style: TextStyle(
            color: signalColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTrailingAction(BuildContext context, BluetoothDeviceDTO dto) {
    if (dto.isConnected) {
      return IconButton(
        onPressed: () {
          context.read<BleController>().disconnect(dto.device);
        },
        icon: const Icon(Icons.link_off, color: Colors.redAccent),
        tooltip: "Disconnect",
      );
    }

    if (dto.isConnectable == true) {
      return IconButton(
        onPressed: () {
          context.read<BleController>().connect(dto.device);
        },
        icon: Icon(Icons.link, color: AppColors.primary),
        tooltip: "Connect",
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildDetailContent(BluetoothDeviceDTO dto) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.5),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (dto.type == DeviceType.iBeacon) ...[
            _buildSectionHeader("iBeacon Data"),
            _buildInfoRow("UUID", dto.beaconUuid ?? "-"),
            Row(
              children: [
                Expanded(child: _buildInfoRow("Major", "${dto.major}")),
                Expanded(child: _buildInfoRow("Minor", "${dto.minor}")),
              ],
            ),
          ],
          if (dto.type == DeviceType.nordic) ...[
            _buildSectionHeader("Nordic Sensor"),
            if (dto.sensorMacId != null)
              _buildInfoRow("MAC ID", dto.sensorMacId!),
            if (dto.temperature != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.thermostat,
                            size: 14,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${dto.temperature}°C",
                            style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            const Text(
              "Payload (ASCII)",
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                dto.rawPayloadString ?? "N/A",
                style: const TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 11,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          _buildInfoRow("Device ID", dto.id),
          if (dto.manufacturerData.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text(
              "Manufacturer Data (HEX)",
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            ...dto.manufacturerData.entries.map((entry) {
              final hexData =
                  entry.value
                      .map((e) => e.toRadixString(16).padLeft(2, '0'))
                      .join(' ')
                      .toUpperCase();
              return Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  "0x${entry.key.toRadixString(16).padLeft(4, '0')}: $hexData",
                  style: const TextStyle(
                    fontSize: 10,
                    fontFamily: 'Courier',
                    color: AppColors.textSecondary,
                  ),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
          SelectableText(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontFamily: 'Courier',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
