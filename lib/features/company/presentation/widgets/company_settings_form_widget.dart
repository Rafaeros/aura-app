import 'package:aura/core/presentation/theme/app_colors.dart';
import 'package:aura/core/presentation/widgets/forms/aura_primary_button.dart';
import 'package:aura/core/presentation/widgets/forms/aura_text_field.dart';
import 'package:aura/core/presentation/widgets/layout/aura_card.dart';
import 'package:aura/features/company/data/model/company_settings_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CompanySettingsForm extends StatefulWidget {
  final CompanySettingsModel? currentSettings;
  final bool isLoading;
  final Function(CompanySettingsModel settings) onSave;

  const CompanySettingsForm({
    super.key,
    this.currentSettings,
    required this.onSave,
    this.isLoading = false,
  });

  @override
  State<CompanySettingsForm> createState() => _CompanySettingsFormState();
}

class _CompanySettingsFormState extends State<CompanySettingsForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _apiKeyController;
  late final TextEditingController _mqttHostController;
  late final TextEditingController _mqttPortController;
  late final TextEditingController _mqttUserController;
  late final TextEditingController _mqttPassController;

  @override
  void initState() {
    super.initState();
    _apiKeyController = TextEditingController(
      text: widget.currentSettings?.everynetAccessToken,
    );
    _mqttHostController = TextEditingController(
      text: widget.currentSettings?.mqttHost,
    );
    _mqttPortController = TextEditingController(
      text: widget.currentSettings?.mqttPort.toString() ?? '8883',
    );
    _mqttUserController = TextEditingController(
      text: widget.currentSettings?.mqttUsername,
    );
    _mqttPassController = TextEditingController(
      text: widget.currentSettings?.mqttPassword,
    );
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _mqttHostController.dispose();
    _mqttPortController.dispose();
    _mqttUserController.dispose();
    _mqttPassController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final settings = CompanySettingsModel(
      everynetAccessToken: _apiKeyController.text,
      mqttHost: _mqttHostController.text,
      mqttPort: int.tryParse(_mqttPortController.text) ?? 8883,
      mqttUsername: _mqttUserController.text,
      mqttPassword: _mqttPassController.text,
    );

    widget.onSave(settings);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AuraCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Everynet"),
            AuraTextField(
              label: "Access Token (API Key)",
              controller: _apiKeyController,
              hint: "sk_live_...",
              behavior: AuraFieldBehavior.password,
              prefixIcon: const Icon(Icons.vpn_key, color: AppColors.primary),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 24),

            _buildSectionTitle("MQTT Broker"),
            AuraTextField(
              label: "Host",
              controller: _mqttHostController,
              hint: "ex: broker.hivemq.com",
              prefixIcon: const Icon(Icons.cloud, color: AppColors.primary),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            AuraTextField(
              label: "Port",
              controller: _mqttPortController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              hint: "ex: 1883 ou 8883",
              prefixIcon: const Icon(Icons.numbers, color: AppColors.primary),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            AuraTextField(
              label: "Username",
              controller: _mqttUserController,
              prefixIcon: const Icon(Icons.person, color: AppColors.primary),
            ),
            const SizedBox(height: 16),

            AuraTextField(
              label: "Password",
              behavior: AuraFieldBehavior.password,
              prefixIcon: const Icon(Icons.lock, color: AppColors.primary),
              controller: _mqttPassController,
            ),

            const SizedBox(height: 40),

            AuraPrimaryButton(
              label: "SAVE SETTINGS",
              icon: Icons.save,
              isLoading: widget.isLoading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
