import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:aura/core/routes/app_routes.dart';
import 'package:aura/core/presentation/theme/app_colors.dart';
import 'package:aura/core/presentation/widgets/app_bar/aura_app_bar.dart';
import 'package:aura/core/presentation/widgets/app_bar/aura_app_bar_action.dart';
import 'package:aura/core/presentation/widgets/app_bar/aura_back_button.dart';
import 'package:aura/core/presentation/widgets/app_bar/aura_popup_menu_item.dart';
import 'package:aura/core/presentation/widgets/layout/aura_card.dart';
import 'package:aura/features/devices/data/models/device_model.dart';
import 'package:aura/features/devices/presentation/controllers/device_controller.dart';
import 'package:aura/features/devices/presentation/widgets/device_map_widget.dart';

class DeviceDetailsScreen extends StatefulWidget {
  final int deviceID;

  const DeviceDetailsScreen({super.key, required this.deviceID});

  @override
  State<DeviceDetailsScreen> createState() => _DeviceDetailsScreenState();
}

class _DeviceDetailsScreenState extends State<DeviceDetailsScreen> {
  DeviceModel? _device;
  bool _isLoadingTags = true;
  bool _isLoadingPositions = true;
  StreamSubscription? _mqttSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initData();
    });
  }

  Future<void> _initData() async {
    await _refreshDeviceDetails();
    if (_device != null) {
      _loadTags();
      _loadPositions();
      _setupMqttListener();
    }
  }

  @override
  void dispose() {
    _mqttSubscription?.cancel();
    super.dispose();
  }

  Future<void> _refreshDeviceDetails() async {
    final controller = Provider.of<DeviceController>(context, listen: false);

    try {
      final freshData = await controller.getDeviceById(widget.deviceID);

      if (freshData != null && mounted) {
        setState(() {
          _device = freshData;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Device not found or deleted"),
              backgroundColor: Colors.redAccent,
            ),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      log("Erro ao buscar detalhes: $e");
      if (mounted) Navigator.pop(context);
    }
  }

  void _setupMqttListener() {
    // TODO: implement mqtt listener
  }

  Future<void> _loadTags() async {
    setState(() => _isLoadingTags = false);
  }

  Future<void> _loadPositions() async {
    setState(() => _isLoadingPositions = false);
  }

  void _copyToClipboard(String text, String label) {
    if (text == '-' || text.isEmpty) return;
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "$label copied to clipboard",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.surface,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_device == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AuraAppBar(
        title: _device?.name ?? "Details",
        icon: Icons.cell_tower_rounded,
        leading: const AuraBackButton(),
        actions: [
          AuraAppBarAction(
            child: PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.more_vert,
                size: 20,
                color: AppColors.textSecondary,
              ),
              color: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
              ),
              onSelected: (value) {
                if (value == 'edit') _editDevice();
                if (value == 'delete') _confirmDeleteDevice();
              },
              itemBuilder:
                  (context) => [
                    AuraPopupMenuItem<String>(
                      value: 'edit',
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                    AuraPopupMenuItem<String>(
                      value: 'delete',
                      icon: Icons.delete,
                      label: 'Delete',
                      iconColor: Colors.redAccent,
                      textColor: Colors.redAccent,
                    ),
                  ],
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 900;

          if (isDesktop) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildInfoCard(),
                            const SizedBox(height: 24),
                            _buildTagsCard(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 6,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(children: [_buildMapCard(height: 600)]),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildInfoCard(),
                  const SizedBox(height: 16),
                  _buildTagsCard(),
                  const SizedBox(height: 16),
                  _buildMapCard(height: 400),
                  const SizedBox(height: 40),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildInfoCard() {
    return _buildCardStructure(
      title: "Information",
      icon: Icons.info_outline,
      child: Column(
        children: [
          _buildDetailRow("Name", _device!.name ?? '-', Icons.person),
          _buildDetailRow("DevEui", _device!.devEui ?? '-', Icons.qr_code),
          _buildDetailRow(
            "DevAddr",
            _device!.devAddr ?? '-',
            Icons.pin_drop_outlined,
          ),
          _buildDetailRow("AppEui", _device!.appEui ?? '-', Icons.api),

          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Column(
              children: [
                _buildDetailRow(
                  "NwksKey",
                  _device!.nwksKey ?? '-',
                  Icons.vpn_key_outlined,
                  isSmall: true,
                ),
                const SizedBox(height: 8),
                _buildDetailRow(
                  "AppsKey",
                  _device!.appsKey ?? '-',
                  Icons.vpn_key_outlined,
                  isSmall: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsCard() {
    final tagsList = _device?.tags ?? [];

    return _buildCardStructure(
      title: "Tags",
      icon: Icons.local_offer_outlined,
      child:
          _isLoadingTags
              ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
              : tagsList.isEmpty
              ? const Text(
                "No tags assigned",
                style: TextStyle(color: AppColors.textSecondary),
              )
              : Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children:
                    tagsList.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          tag.name,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }).toList(),
              ),
    );
  }

  Widget _buildMapCard({required double height}) {
    Widget content;
    final positionList = _device?.positions ?? [];

    if (_isLoadingPositions) {
      content = const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    } else if (positionList.isEmpty) {
      content = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off_rounded,
            size: 40,
            color: AppColors.textSecondary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              "No GPS data",
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      );
    } else {
      content = DeviceMapWidget(positions: positionList);
    }

    return _buildCardStructure(
      title: "Geolocation",
      icon: Icons.map_rounded,
      trailing:
          !_isLoadingPositions && positionList.isNotEmpty
              ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  "Last 5 points",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
              : null,
      child: SizedBox(
        height: height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: content,
        ),
      ),
    );
  }
  Widget _buildCardStructure({
    required Widget child,
    required String title,
    required IconData icon,
    Widget? trailing,
  }) {
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
                  Icon(icon, color: AppColors.primary, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    IconData icon, {
    bool canCopy = true,
    bool isSmall = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        value,
                        style: TextStyle(
                          fontSize: isSmall ? 12 : 14,
                          fontFamily: 'monospace',
                          color: AppColors.textPrimary,
                          fontWeight:
                              isSmall ? FontWeight.normal : FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (canCopy && value != '-')
                      InkWell(
                        onTap: () => _copyToClipboard(value, label),
                        borderRadius: BorderRadius.circular(20),
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.copy_rounded,
                            size: 14,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteDevice() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.surface,
            title: const Text(
              'Delete device',
              style: TextStyle(color: AppColors.textPrimary),
            ),
            content: const Text(
              'This action is irreversible.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await _deleteDevice();
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
    );
  }

  void _editDevice() async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.deviceEdit,
      arguments: _device!,
    );

    if (result is DeviceModel) {
      setState(() {
        _device = result;
      });
    }
  }

  Future<void> _deleteDevice() async {
    final controller = Provider.of<DeviceController>(context, listen: false);
    try {
      await controller.deleteDevice(_device!.id!);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Deleted successfully')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}
