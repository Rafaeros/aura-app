import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:aura/core/exception/app_exception.dart';
import 'package:aura/core/presentation/theme/app_colors.dart';
import 'package:aura/core/presentation/widgets/app_bar/aura_app_bar.dart';
import 'package:aura/core/presentation/widgets/app_bar/aura_back_button.dart';
import 'package:aura/core/presentation/widgets/forms/aura_primary_button.dart';
import 'package:aura/core/presentation/widgets/forms/aura_text_field.dart';
import 'package:aura/core/presentation/widgets/layout/aura_card.dart';
import 'package:aura/core/routes/app_routes.dart';
import 'package:aura/core/utils/ui_message_handler.dart';
import 'package:aura/features/auth/presentation/controllers/login_controller.dart';

class FirstAccessScreen extends StatefulWidget {
  const FirstAccessScreen({super.key, required this.email});
  final String email;

  @override
  State<FirstAccessScreen> createState() => _FirstAccessScreenState();
}

class _FirstAccessScreenState extends State<FirstAccessScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _tempPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
  }

  Future<void> _activateAccount() async {
    if (!_formKey.currentState!.validate()) return;
    if (_newPassController.text != _confirmPassController.text) {
      UiMessageHandler.handle(
        context,
        AppException(
          message: "Passwords do not match.",
          severity: ErrorSeverity.WARNING,
        ),
      );
      return;
    }
    if (_tempPassController.text == _newPassController.text) {
      UiMessageHandler.handle(
        context,
        AppException(
          message: "New password must be different from current password.",
          severity: ErrorSeverity.WARNING,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final nextRoute = await context.read<LoginController>().activateAccount(
        _emailController.text,
        _tempPassController.text,
        _newPassController.text,
        _confirmPassController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Account activated!"),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      if (nextRoute != null) {
        Navigator.pushNamedAndRemoveUntil(context, nextRoute, (_) => false);
      }
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
      appBar: AuraAppBar(
        title: "Activate Account",
        actions: const [],
        leading: AuraBackButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
              (_) => false,
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome!",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "To activate your account, please confirm your details and set a new password.",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            AuraCard(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AuraTextField(
                      label: "E-mail",
                      controller: _emailController,
                      hint: "Ex: example@gmail.com",
                      readOnly: true,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: AppColors.primary,
                      ),
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 20),
                    AuraTextField(
                      label: "Current password",
                      controller: _tempPassController,
                      hint: "Ex: Mudar@123",
                      behavior: AuraFieldBehavior.password,
                      prefixIcon: const Icon(
                        Icons.vpn_key_outlined,
                        color: AppColors.primary,
                      ),
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: Colors.white10, height: 1),
                    const SizedBox(height: 24),
                    const Text(
                      "Set New Password",
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AuraTextField(
                      label: "New password",
                      controller: _newPassController,
                      behavior: AuraFieldBehavior.password,
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: AppColors.primary,
                      ),
                      validator:
                          (v) =>
                              (v != null && v.length < 6)
                                  ? 'Mínimo 6 caracteres'
                                  : null,
                    ),
                    const SizedBox(height: 16),
                    AuraTextField(
                      label: "Confirm new password",
                      controller: _confirmPassController,
                      behavior: AuraFieldBehavior.password,
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: AppColors.primary,
                      ),
                      validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
                    ),
                    const SizedBox(height: 32),
                    AuraPrimaryButton(
                      label: "Activate Account",
                      isLoading: _isLoading,
                      icon: Icons.check_circle_outline_rounded,
                      onPressed: _activateAccount,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
