import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:aura/core/presentation/theme/app_colors.dart';
import 'package:aura/features/ble/presentation/controllers/ble_controller.dart';

class BleControlBar extends StatelessWidget {
  const BleControlBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BleController>();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
                  controller.isScanning
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : AppColors.textSecondary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.radar,
              color:
                  controller.isScanning
                      ? AppColors.primary
                      : AppColors.textSecondary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.isScanning ? "Scanning..." : "Idle",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  controller.isScanning
                      ? "Discovering devices..."
                      : "Ready to scan.",
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          _buildActionButton(controller),
        ],
      ),
    );
  }

  Widget _buildActionButton(BleController controller) {
    if (controller.isScanning) {
      return OutlinedButton(
        onPressed: controller.stopScan,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.5)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        child: const Icon(Icons.stop_rounded, color: Colors.redAccent),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: controller.startScan,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        child: const Icon(Icons.play_arrow_rounded, color: Colors.white),
      ),
    );
  }
}
