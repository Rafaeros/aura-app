import 'package:flutter/material.dart';

import 'package:aura/core/presentation/theme/app_colors.dart';
import 'package:aura/core/presentation/widgets/app_bar/aura_app_bar.dart';
import 'package:aura/core/presentation/widgets/layout/aura_card.dart';
import 'package:aura/core/presentation/widgets/layout/paged_list_view.dart';
import 'package:aura/core/routes/app_routes.dart';
import 'package:aura/features/devices/presentation/controllers/device_controller.dart';
import 'package:aura/features/devices/presentation/widgets/device_list_item_widget.dart';
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
        context.read<DeviceController>().loadDevices(refresh: true);
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
      body: _buildBody(deviceController),
    );
  }

  Widget _buildBody(DeviceController controller) {
    if (controller.isLoading && controller.devices.isEmpty) {
      return _buildLoadingShimmer();
    }
    return PagedListView<dynamic>(
      items: controller.devices,
      isLoading: controller.isLoading,
      hasError: controller.errorMessage != null,
      errorMessage: controller.errorMessage,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      onRefresh: () => controller.loadDevices(refresh: true),
      onLoadMore: () => controller.loadDevices(refresh: false),
      emptyStateWidget: _buildEmptyState(),
      itemBuilder: (context, device) {
        return DeviceListItem(
          device: device,
          onTap: () async {
            await Navigator.pushNamed(
              context,
              AppRoutes.deviceDetails,
              arguments: {'id': device.id},
            );
          },
        );
      },
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
        onPressed: () async {
          final navigator = Navigator.of(context);
          final deviceController = context.read<DeviceController>();

          await navigator.pushNamed(AppRoutes.addDevice);

          if (!mounted) return;

          deviceController.loadDevices(refresh: true);
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      itemCount: 6,
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
}
