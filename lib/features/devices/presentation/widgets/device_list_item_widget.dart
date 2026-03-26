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
    final displayName = (device.name != null && device.name!.isNotEmpty)
        ? device.name!
        : "Dispositivo Sem Nome";

    final displayEui = device.devEui ?? "N/A";

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AuraCard(
        onTap: onTap,
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                  _buildTags(),
                ],
              ),
            ),
            const SizedBox(width: 8),
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

  Widget _buildTags() {
    if (device.tags == null || device.tags!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
        height: 24, 
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: device.tags!.length,
          separatorBuilder: (_, __) => const SizedBox(width: 6),
          itemBuilder: (context, index) {
            final tag = device.tags![index];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.center, 
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  width: 0.5,
                ),
              ),
              child: Text(
                tag.name,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary.withValues(alpha: 0.9),
                ),
              ),
            );
          },
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