import 'package:aura/core/presentation/theme/app_colors.dart';
import 'package:aura/core/presentation/widgets/app_bar/aura_app_bar.dart';
import 'package:aura/core/presentation/widgets/app_bar/aura_back_button.dart';
import 'package:aura/core/utils/ui_message_handler.dart';
import 'package:aura/features/company/data/model/company_settings_model.dart';
import 'package:aura/features/company/presentation/controllers/company_settings_controller.dart';
import 'package:aura/features/company/presentation/widgets/company_settings_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompanySettingsEditScreen extends StatefulWidget {
  final CompanySettingsModel? currentSettings;

  const CompanySettingsEditScreen({super.key, this.currentSettings});

  @override
  State<CompanySettingsEditScreen> createState() =>
      _CompanySettingsEditScreenState();
}

class _CompanySettingsEditScreenState extends State<CompanySettingsEditScreen> {
  bool _isLoading = false;

  Future<void> _handleUpdate(CompanySettingsModel newSettings) async {
    setState(() => _isLoading = true);

    try {
      await context.read<CompanySettingsController>().saveSettings(newSettings);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Integrations updated successfully!"),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context, true);
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
        title: "Integrations",
        icon: Icons.settings,
        leading: AuraBackButton(),
        actions: [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildHeader(),

            const SizedBox(height: 32),

            CompanySettingsForm(
              currentSettings: widget.currentSettings,
              isLoading: _isLoading,
              onSave: _handleUpdate,
            ),

            const SizedBox(height: 40),

            Text(
              "Changes affect real-time data collection.",
              style: TextStyle(
                color: AppColors.textSecondary.withValues(alpha: 0.5),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const SizedBox(height: 16),
        const Text(
          "Connection Setup",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Manage the connection parameters for Everynet and your MQTT Broker.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
