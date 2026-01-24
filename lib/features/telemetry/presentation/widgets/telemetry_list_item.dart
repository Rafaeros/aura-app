import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:convert';

import 'package:aura/core/presentation/theme/app_colors.dart';
import 'package:aura/features/telemetry/data/models/device_telemetry_model.dart';
import 'package:intl/intl.dart';

class TelemetryListItem extends StatelessWidget {
  final DeviceTelemetryModel telemetry;

  const TelemetryListItem({super.key, required this.telemetry});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> payload = telemetry.payload;
    Map<String, dynamic> params = payload['params'] ?? {};
    List<dynamic> solutions =
        (params['solutions'] is List) ? params['solutions'] : [];

    Map<String, dynamic> radio = params['radio'] ?? {};
    Map<String, dynamic> hardware = radio['hardware'] ?? radio['data'] ?? {};

    double lat = 0.0;
    double lng = 0.0;
    double frequency = (radio['freq'] as num?)?.toDouble() ?? 0.0;
    int? rssi = hardware['rssi'];

    final type = telemetry.type.toUpperCase();
    final isUplink = type == 'UPLINK';
    final isLocation = type == 'LOCATION';

    if (solutions.isNotEmpty) {
      lat = (solutions[0]['lat'] as num?)?.toDouble() ?? 0.0;
      lng = (solutions[0]['lng'] as num?)?.toDouble() ?? 0.0;
    }

    String timeString = "--:--";
    if (telemetry.createdAt != null) {
      try {
        final parsedDate = DateTime.parse(telemetry.createdAt!).toLocal();
        timeString = DateFormat('HH:mm:ss \n dd/MM').format(parsedDate);
      } catch (_) {}
    }

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getColorByType(type).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getIconByType(type, isLocation, isUplink),
            color: _getColorByType(type),
            size: 20,
          ),
        ),

        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              type,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              timeString,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),

        subtitle: _buildSubtitle(lat, lng, frequency, rssi),

        children: [_buildJsonViewer(context, payload)],
      ),
    );
  }

  Color _getColorByType(String type) {
    if (type == 'LOCATION') return AppColors.info;
    if (type == 'UPLINK') return Colors.green;
    if (type == 'DOWNLINK') return Colors.purpleAccent;
    return Colors.grey;
  }

  IconData _getIconByType(String type, bool isLocation, bool isUplink) {
    if (isLocation) return Icons.location_on_rounded;
    if (isUplink) return Icons.keyboard_double_arrow_up_outlined;
    if (type == 'DOWNLINK') return Icons.keyboard_double_arrow_down_outlined;
    return Icons.data_usage;
  }

  Widget _buildSubtitle(double lat, double lng, double freq, int? rssi) {
    if (lat != 0.0 || lng != 0.0) {
      return Text(
        "${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}",
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
      );
    }
    if (freq > 0 || rssi != null) {
      return Text(
        "${rssi != null ? '$rssi dBm | ' : ''}${freq.toStringAsFixed(1)} MHz",
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
      );
    }
    return const Text(
      "View payload",
      style: TextStyle(fontSize: 11, color: Colors.grey),
    );
  }

  Widget _buildJsonViewer(BuildContext context, Map<String, dynamic> json) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "RAW PAYLOAD",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: _prettyPrint(json)));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("JSON Copied!"),
                      duration: Duration(milliseconds: 800),
                    ),
                  );
                },
                child: const Icon(
                  Icons.copy,
                  size: 14,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SelectableText(
            _prettyPrint(json),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontFamily: 'monospace',
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  String _prettyPrint(Map<String, dynamic> json) {
    var encoder = const JsonEncoder.withIndent("  ");
    return encoder.convert(json);
  }
}
