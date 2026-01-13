import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:aura/core/presentation/theme/app_colors.dart';
import 'package:aura/features/devices/data/models/device_position.dart';

class DeviceMapWidget extends StatefulWidget {
  final List<DevicePosition> positions;

  const DeviceMapWidget({super.key, required this.positions});

  @override
  State<DeviceMapWidget> createState() => _DeviceMapWidgetState();
}

class _DeviceMapWidgetState extends State<DeviceMapWidget> {
  final MapController _mapController = MapController();

  @override
  void didUpdateWidget(covariant DeviceMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.positions.isNotEmpty &&
        widget.positions != oldWidget.positions) {
      final latestPosition = widget.positions.first;
      _mapController.move(
        LatLng(latestPosition.latitude, latestPosition.longitude),
        15.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.positions.isEmpty) return const SizedBox();

    final points =
        widget.positions.map((p) => LatLng(p.latitude, p.longitude)).toList();

    final latestPos = widget.positions.first;

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: LatLng(latestPos.latitude, latestPos.longitude),
            initialZoom: 15,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            ),
          ),
          children: [
            ColorFiltered(
              colorFilter: const ColorFilter.matrix(<double>[
                -1,
                0,
                0,
                0,
                255,
                0,
                -1,
                0,
                0,
                255,
                0,
                0,
                -1,
                0,
                255,
                0,
                0,
                0,
                1,
                0,
              ]),
              child: TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'br.rafaeros.aura',
              ),
            ),

            PolylineLayer(
              polylines: [
                Polyline(
                  points: points,
                  strokeWidth: 2.0,
                  color: AppColors.primary.withValues(alpha: 0.5),
                  strokeJoin: StrokeJoin.round,
                  strokeCap: StrokeCap.round,
                ),
              ],
            ),
            MarkerLayer(
              markers:
                  widget.positions.asMap().entries.map((entry) {
                    final index = entry.key;
                    final p = entry.value;
                    final isLatest = index == 0;

                    return Marker(
                      point: LatLng(p.latitude, p.longitude),
                      width: 80,
                      height: 80,
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: -25,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surface.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color:
                                      isLatest
                                          ? AppColors.primary
                                          : AppColors.textSecondary.withValues(
                                            alpha: 0.3,
                                          ),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "${p.latitude.toStringAsFixed(4)}, ${p.longitude.toStringAsFixed(4)}",
                                    style: TextStyle(
                                      color:
                                          isLatest
                                              ? AppColors.textPrimary
                                              : AppColors.textSecondary,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                  /* Icon(Icons.arrow_drop_down, size: 10, color: AppColors.surface) */
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Icon(
                              Icons.location_pin,
                              size: isLatest ? 40 : 30,
                              color:
                                  isLatest
                                      ? AppColors.primary
                                      : AppColors.textSecondary.withValues(
                                        alpha: 0.5,
                                      ),
                              shadows: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
        IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.surface.withValues(alpha: 0.1),
                  Colors.transparent,
                  Colors.transparent,
                  AppColors.surface.withValues(alpha: 0.1),
                ],
                stops: const [0.0, 0.1, 0.9, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
