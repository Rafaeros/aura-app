import 'package:aura/core/utils/app_notifications.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:aura/core/presentation/theme/app_colors.dart';
import 'package:aura/core/presentation/widgets/app_bar/aura_app_bar.dart';
import 'package:aura/core/presentation/widgets/app_bar/aura_back_button.dart';
import 'package:aura/core/utils/ui_message_handler.dart';
import 'package:aura/features/company/data/model/company_settings_model.dart';
import 'package:aura/features/company/presentation/controllers/company_settings_controller.dart';
import 'package:aura/features/company/presentation/widgets/company_settings_form_widget.dart';

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

      AppNotifications.showSuccess(
        context: context,
        message: "Integrações atualizadas com sucesso!",
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
        title: "Integrações",
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
              "As alterações afetam a coleta de dados em tempo real.",
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
          "Configuração de Conexão",
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
            "Gerencie os parâmetros de conexão do Everynet e seu Broker MQTT.",
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
