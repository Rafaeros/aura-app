import 'package:flutter/material.dart';

import 'package:aura/core/presentation/theme/app_colors.dart';
import 'package:aura/core/presentation/widgets/layout/aura_card.dart';
import 'package:aura/features/telemetry/presentation/controllers/telemetry_connection_controller.dart';
import 'package:provider/provider.dart';

class MqttStatusCard extends StatelessWidget {
  const MqttStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TelemetryConnectionController>();
    final status = controller.uiStatus;

    Color statusColor = Colors.grey;
    String statusLabel = "Offline";
    IconData statusIcon = Icons.cloud_off_rounded;
    String buttonLabel = "Connect";
    Color buttonColor = AppColors.primary;

    switch (status) {
      case MqttUiStatus.connected:
        statusColor = Colors.greenAccent;
        statusLabel = "Online";
        statusIcon = Icons.cloud_done_rounded;
        buttonLabel = "Disconnect";
        buttonColor = Colors.redAccent;
        break;
      case MqttUiStatus.connecting:
        statusColor = Colors.orangeAccent;
        statusLabel = "Connecting...";
        statusIcon = Icons.sync;
        buttonLabel = "Cancel";
        buttonColor = Colors.orange;
        break;
      case MqttUiStatus.error:
        statusColor = Colors.redAccent;
        statusLabel = "Error";
        statusIcon = Icons.error_outline_rounded;
        buttonLabel = "Retry";
        buttonColor = AppColors.primary;
        break;
      case MqttUiStatus.disconnected:
    }

    return AuraCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: statusColor.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Icon(statusIcon, color: statusColor, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "MQTT Status",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        statusLabel,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withValues(alpha: 0.6),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (controller.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        controller.errorMessage!,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              onPressed: () {
                controller.toggleConnection();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor.withValues(alpha: 0.2),
                foregroundColor: buttonColor,
                elevation: 0,
                side: BorderSide(color: buttonColor.withValues(alpha: 0.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child:
                  status == MqttUiStatus.connecting
                      ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: buttonColor,
                        ),
                      )
                      : Text(
                        buttonLabel.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
