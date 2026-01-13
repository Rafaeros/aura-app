import 'package:flutter/material.dart';
import '../../../../core/presentation/theme/app_colors.dart';

class BleEmptyState extends StatelessWidget {
  const BleEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.bluetooth_disabled_rounded,
              size: 48,
              color: AppColors.textSecondary.withValues(alpha: 0.3),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "No devices found",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Pull down to refresh or tap Start",
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
