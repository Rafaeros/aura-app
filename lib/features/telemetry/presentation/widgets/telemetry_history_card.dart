import 'package:flutter/material.dart';

import 'package:aura/core/presentation/theme/app_colors.dart';
import 'package:aura/core/presentation/widgets/layout/aura_card.dart';
import 'package:aura/features/telemetry/data/models/device_telemetry_model.dart';
import 'package:aura/features/telemetry/presentation/widgets/telemetry_list_item.dart';
class TelemetryHistoryCard extends StatelessWidget {
  final List<DeviceTelemetryModel> telemetries;
  final VoidCallback? onViewAll; 

  const TelemetryHistoryCard({
    super.key,
    required this.telemetries,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    if (telemetries.isEmpty) {
      return _buildEmptyState();
    }

    return AuraCard(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.history_edu_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Logs",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                if (onViewAll != null)
                  InkWell(
                    onTap: onViewAll,
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Text(
                        "View All",
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primary.withValues(alpha: 0.8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: telemetries.length,
            separatorBuilder:
                (c, i) => Divider(
                  color: Colors.white.withValues(alpha: 0.05),
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                ),
            itemBuilder: (context, index) {
              return TelemetryListItem(telemetry: telemetries[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return AuraCard(
      padding: const EdgeInsets.all(20),
      child: const Center(
        child: Text(
          "No telemetry history available.",
          style: TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
