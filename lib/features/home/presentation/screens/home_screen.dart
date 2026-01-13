import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:aura/core/presentation/theme/app_colors.dart';
import 'package:aura/features/ble/presentation/screens/ble_scan_screen.dart';
import 'package:aura/features/devices/presentation/screens/devices_screen.dart';
import 'package:aura/features/home/presentation/controllers/home_controller.dart';
import 'package:aura/features/home/presentation/screens/dashboard_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final home = context.watch<HomeController>();
    final List<Widget> screens = [
      const DashboardScreen(),
      const DevicesScreen(),
      const BleScanScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: home.currentIndex, children: screens),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(
              color: Colors.white.withValues(alpha: 0.05),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: home.currentIndex,
          onTap: home.changeTab,

          backgroundColor: Colors.transparent,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            height: 1.5,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
            height: 1.5,
          ),

          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: [
            _buildNavItem(icon: Icons.dashboard_rounded, label: "Dashboard"),
            _buildNavItem(icon: Icons.devices_other_rounded, label: "Devices"),
            _buildNavItem(icon: Icons.bluetooth, label: "BLE Scan"),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required IconData icon,
    required String label,
  }) {
    return BottomNavigationBarItem(icon: Icon(icon), label: label);
  }
}
