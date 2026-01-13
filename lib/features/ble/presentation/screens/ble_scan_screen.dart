import 'package:aura/core/presentation/widgets/app_bar/aura_app_bar.dart';
import 'package:aura/core/presentation/theme/app_colors.dart';
import 'package:aura/features/ble/data/dtos/ble_device_dto.dart';
import 'package:aura/features/ble/presentation/controllers/ble_controller.dart';
import 'package:aura/features/ble/presentation/widgets/ble_control_bar.dart';
import 'package:aura/features/ble/presentation/widgets/ble_device_card.dart';
import 'package:aura/features/ble/presentation/widgets/ble_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BleScanScreen extends StatefulWidget {
  const BleScanScreen({super.key});

  @override
  State<BleScanScreen> createState() => _BleScanScreenState();
}

class _BleScanScreenState extends State<BleScanScreen> {
  bool showOnlyBeacons = false;

  @override
  Widget build(BuildContext context) {
    final bleController = context.watch<BleController>();

    final filteredResults =
        showOnlyBeacons
            ? bleController.scannedDevices
                .where((d) => d.type != DeviceType.classic)
                .toList()
            : bleController.scannedDevices;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AuraAppBar(title: "Aura BLE Scanner", icon: Icons.bluetooth),
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        onRefresh: () async {
          await bleController.stopScan();
          await bleController.startScan();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (bleController.errorMessage != null)
              _buildErrorBanner(bleController.errorMessage!),
            const BleControlBar(),

            _buildFilterSwitch(),

            Expanded(
              child:
                  filteredResults.isEmpty
                      ? const BleEmptyState()
                      : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 100),
                        itemCount: filteredResults.length,
                        itemBuilder: (context, index) {
                          final dto = filteredResults[index];
                          return BleDeviceCard(deviceDto: dto);
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSwitch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            "Only Beacons",
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: showOnlyBeacons,
            onChanged: (v) => setState(() => showOnlyBeacons = v),
            activeThumbColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withValues(alpha: 0.3),
            inactiveThumbColor: AppColors.textSecondary,
            inactiveTrackColor: AppColors.surface,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner(String error) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.redAccent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              error,
              style: const TextStyle(color: Colors.redAccent, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
