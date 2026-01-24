import 'package:flutter/material.dart';

import 'package:aura/core/presentation/theme/app_colors.dart';
import 'package:aura/core/presentation/widgets/app_bar/aura_app_bar.dart';
import 'package:aura/core/presentation/widgets/app_bar/aura_back_button.dart';
import 'package:aura/core/presentation/widgets/layout/paged_list_view.dart';
import 'package:aura/features/telemetry/presentation/controllers/telemetry_history_controller.dart';
import 'package:aura/features/telemetry/presentation/widgets/telemetry_list_item.dart';
import 'package:provider/provider.dart';

class TelemetryHistoryScreen extends StatefulWidget {
  final int deviceId;
  final String deviceName;

  const TelemetryHistoryScreen({
    super.key,
    required this.deviceId,
    required this.deviceName,
  });

  @override
  State<TelemetryHistoryScreen> createState() => _TelemetryHistoryScreenState();
}

class _TelemetryHistoryScreenState extends State<TelemetryHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TelemetryHistoryController>().refresh(widget.deviceId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AuraAppBar(
        title: "History: ${widget.deviceName}",
        leading: const AuraBackButton(),
      ),
      body: Consumer<TelemetryHistoryController>(
        builder: (context, controller, child) {
          return PagedListView(
            items: controller.telemetries,
            isLoading: controller.isLoading,
            hasError: controller.hasError,
            errorMessage: controller.errorMessage,
            onRefresh: () async => controller.refresh(widget.deviceId),
            onLoadMore: () => controller.loadTelemetries(widget.deviceId),
            padding: const EdgeInsets.only(
              top: 16,
              left: 16,
              right: 16,
              bottom: 40,
            ),

            itemBuilder: (context, telemetry) {
              return TelemetryListItem(telemetry: telemetry);
            },

            emptyStateWidget: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history_toggle_off,
                    size: 60,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "No telemetry logs found",
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
