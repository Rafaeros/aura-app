import 'package:aura/core/utils/app_notifications.dart';
import 'package:aura/core/presentation/widgets/app_bar/aura_back_button.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:aura/core/presentation/theme/app_colors.dart';
import 'package:aura/core/presentation/widgets/app_bar/aura_app_bar.dart';
import 'package:aura/core/routes/app_routes.dart';
import 'package:aura/core/utils/ui_message_handler.dart';
import 'package:aura/features/company/data/model/company_settings_model.dart';
import 'package:aura/features/company/presentation/controllers/company_settings_controller.dart';
import 'package:aura/features/company/presentation/widgets/company_settings_form_widget.dart';

class CompanyInitialSetupScreen extends StatefulWidget {
  const CompanyInitialSetupScreen({super.key});

  @override
  State<CompanyInitialSetupScreen> createState() =>
      _CompanyInitialSetupScreenState();
}

class _CompanyInitialSetupScreenState extends State<CompanyInitialSetupScreen> {
  bool _isLoading = false;

  Future<void> _handleSetup(CompanySettingsModel settings) async {
    setState(() => _isLoading = true);

    try {
      await context.read<CompanySettingsController>().saveSettings(settings);
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);

      AppNotifications.showSuccess(
        context: context,
        message: "Configuração concluída. Bem-vindo(a) ao Aura!",
      );
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
        icon: Icons.settings,
        title: "Configuração de Integração",
        leading: AuraBackButton(),
        actions: [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Bem-vindo(a)!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Para começar a usar o Aura, instale a conexão com Everynet e seu Broker MQTT.",
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            CompanySettingsForm(isLoading: _isLoading, onSave: _handleSetup),
          ],
        ),
      ),
    );
  }
}
