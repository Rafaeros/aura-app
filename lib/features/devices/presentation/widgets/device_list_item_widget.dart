import 'package:flutter/material.dart';

import 'package:aura/core/presentation/theme/app_colors.dart';
import 'package:aura/core/presentation/widgets/layout/aura_card.dart';
import 'package:aura/features/devices/data/models/device_model.dart';

class DeviceListItem extends StatelessWidget {
  final DeviceModel device;
  final VoidCallback? onTap;

  const DeviceListItem({super.key, required this.device, this.onTap});

  @override
  Widget build(BuildContext context) {
    final displayName =
        (device.name != null && device.name!.isNotEmpty)
            ? device.name!
            : "Unnamed Device";

    final displayEui = device.devEui ?? "N/A";

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AuraCard(
        onTap: onTap,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildIconContainer(),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "DEVEUI: ",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary.withValues(alpha: 0.6),
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        displayEui,
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Courier',
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary.withValues(alpha: 0.4),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconContainer() {
    IconData icon = Icons.sensors;
    final safeName = (device.name ?? "").toLowerCase();

    if (safeName.contains("track")) icon = Icons.gps_fixed;
    if (safeName.contains("tag")) icon = Icons.nfc;

    return Container(
      width: 48,
      height: 48,
      decoration: const BoxDecoration(
        color: AppColors.accent,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColors.primary, size: 24),
    );
  }
}
