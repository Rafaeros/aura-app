import 'package:aura/core/presentation/theme/app_colors.dart';
import 'package:aura/core/presentation/widgets/app_bar/aura_app_bar.dart';
import 'package:aura/core/presentation/widgets/layout/aura_card.dart';
import 'package:aura/core/routes/app_routes.dart';
import 'package:aura/features/devices/presentation/controllers/device_controller.dart';
import 'package:aura/features/devices/presentation/widgets/device_list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<DeviceController>().loadDevices();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceController = context.watch<DeviceController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AuraAppBar(
        title: 'Aura Devices',
        icon: Icons.devices_other_rounded,
      ),
      floatingActionButton: _buildFab(context),
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        onRefresh: () => deviceController.loadDevices(),
        child: _buildBody(deviceController),
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addDevice),
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
      ),
    );
  }

  Widget _buildBody(DeviceController controller) {
    if (controller.isLoading) {
      return _buildLoadingShimmer();
    }

    if (controller.errorMessage != null) {
      return _buildErrorState(controller);
    }

    if (controller.devices.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
      itemCount: controller.devices.length,
      itemBuilder: (context, index) {
        final device = controller.devices[index];

        return DeviceListItem(
          device: device,
          onTap: () async {
            await Navigator.pushNamed(
              context,
              AppRoutes.deviceDetails,
              arguments: {'id': device.id},
            );

            if (mounted) {
              controller.loadDevices();
            }
          },
        );
      },
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      itemCount: 5,
      itemBuilder:
          (_, __) => const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: SizedBox(height: 90, child: AuraCard(child: SizedBox())),
          ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: AuraCard(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.sensors_off_rounded,
                size: 40,
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "No Devices found",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Add a new device to the Aura network",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(DeviceController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.signal_wifi_off_rounded,
              color: Colors.redAccent.shade200,
              size: 50,
            ),
            const SizedBox(height: 20),
            Text(
              "Connection Lost",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage ?? "Unknown error",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => controller.loadDevices(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text("Reconnect"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
