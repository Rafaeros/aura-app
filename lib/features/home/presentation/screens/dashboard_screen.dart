import 'package:flutter/material.dart';

import 'package:aura/core/presentation/theme/app_colors.dart';
import 'package:aura/core/presentation/widgets/app_bar/aura_app_bar.dart';
import 'package:aura/core/presentation/widgets/app_bar/user_profile_action_button.dart';
import 'package:aura/core/presentation/widgets/layout/aura_card.dart';
import 'package:aura/features/home/presentation/controllers/home_controller.dart';
import 'package:aura/features/telemetry/presentation/widgets/mqtt_status_card.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AuraAppBar(
        title: "Aura Dashboard",
        icon: Icons.dashboard,
        actions: [UserProfileActionButton()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MqttStatusCard(),

            const SizedBox(height: 24),
            const Text(
              "Quick Actions",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _ActionCard(
                    title: "My Devices",
                    icon: Icons.devices_other_rounded,
                    color: Colors.blueAccent,
                    onTap: () {
                      context.read<HomeController>().changeTab(1);
                    },
                  ),
                  _ActionCard(
                    title: "Scanner BLE",
                    icon: Icons.radar_rounded,
                    color: Colors.purpleAccent,
                    onTap: () {
                      context.read<HomeController>().changeTab(2);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AuraCard(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
