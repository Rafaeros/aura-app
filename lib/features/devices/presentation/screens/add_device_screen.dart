import 'package:aura/core/presentation/theme/app_colors.dart';
import 'package:aura/core/presentation/widgets/app_bar/aura_app_bar.dart';
import 'package:aura/core/presentation/widgets/app_bar/aura_back_button.dart';
import 'package:aura/core/utils/ui_message_handler.dart';
import 'package:aura/features/devices/presentation/controllers/device_controller.dart';
import 'package:aura/features/devices/presentation/widgets/add_device_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({super.key});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  bool _isLoading = false;

  Future<void> _handleSaveDevice(Map<String, String> deviceData) async {
    setState(() => _isLoading = true);

    try {
      final controller = context.read<DeviceController>();
      await controller.registerDevice(
        deviceData['name'] ?? '',
        deviceData['dev_eui'] ?? '',
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Device registered successfully!"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        UiMessageHandler.handle(context, e);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AuraAppBar(
        title: "Register Device",
        leading: AuraBackButton(),
        actions: [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildHeroSection(),
            const SizedBox(height: 30),
            AddDeviceForm(isLoading: _isLoading, onSave: _handleSaveDevice),
            const SizedBox(height: 40),
            Text(
              'v1.0.0',
              style: TextStyle(
                color: AppColors.textSecondary.withValues(alpha: 0.6),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.add_link_rounded,
            color: Colors.white,
            size: 40,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Add New Device',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Register your hardware to the network',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
