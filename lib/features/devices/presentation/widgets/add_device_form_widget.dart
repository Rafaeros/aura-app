import 'package:flutter/material.dart';

import 'package:aura/core/presentation/theme/app_colors.dart';
import 'package:aura/core/presentation/widgets/forms/aura_primary_button.dart';
import 'package:aura/core/presentation/widgets/forms/aura_text_field.dart';
import 'package:aura/core/presentation/widgets/layout/aura_card.dart';
import 'package:aura/core/utils/ui_message_handler.dart';

class AddDeviceForm extends StatefulWidget {
  final bool isLoading;
  final Future<void> Function(Map<String, String> data) onSave;

  const AddDeviceForm({
    super.key,
    required this.onSave,
    this.isLoading = false,
  });

  @override
  State<AddDeviceForm> createState() => _AddDeviceFormState();
}

class _AddDeviceFormState extends State<AddDeviceForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _devEuiController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _devEuiController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    try {
      await widget.onSave({
        'name': _nameController.text.trim(),
        'dev_eui': _devEuiController.text.trim(),
      });
      
    } catch (error) {
      if (mounted) {
        UiMessageHandler.handle(context, error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuraCard(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Detalhes do Dispositivo",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 24),

            AuraTextField(
              label: "Nome do Dispositivo",
              controller: _nameController,
              hint: "ex: Sensor da Sala",
              prefixIcon: const Icon(
                Icons.devices_other_rounded,
                color: AppColors.primary,
              ),
              validator: (v) => (v == null || v.isEmpty) ? 'Obrigatório' : null,
            ),

            const SizedBox(height: 20),
            AuraTextField(
              label: "Dev EUI",
              controller: _devEuiController,
              hint: "Identificador Único (16 carac.)",
              prefixIcon: const Icon(
                Icons.qr_code_2_rounded,
                color: AppColors.primary,
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Obrigatório';
                if (v.length < 15) return 'EUI Inválido (muito curto)';
                return null;
              },
            ),

            const SizedBox(height: 12),
            const Text(
              'Identificador único da API Everynet',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),

            const SizedBox(height: 32),

            AuraPrimaryButton(
              label: "CONFIRMAR REGISTRO",
              icon: Icons.check_circle_rounded,
              isLoading: widget.isLoading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}