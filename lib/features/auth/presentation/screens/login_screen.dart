import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:aura/core/presentation/theme/app_colors.dart';
import 'package:aura/core/presentation/widgets/forms/aura_primary_button.dart';
import 'package:aura/core/presentation/widgets/forms/aura_text_field.dart';
import 'package:aura/core/presentation/widgets/layout/aura_card.dart';
import 'package:aura/core/routes/app_routes.dart';
import 'package:aura/core/utils/ui_message_handler.dart';
import 'package:aura/features/auth/presentation/controllers/login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginController = context.watch<LoginController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildHeader(),
              const SizedBox(height: 40),
              AuraCard(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 32),

                    AuraTextField(
                      label: "Email",
                      controller: _emailController,
                      hint: "example@gmail.com",
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: AppColors.primary,
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 24),

                    AuraTextField(
                      label: "Password",
                      controller: _passwordController,
                      hint: "Enter your password",
                      prefixIcon: const Icon(
                        Icons.lock_outlined,
                        color: AppColors.primary,
                      ),
                      behavior: AuraFieldBehavior.password,
                    ),

                    const SizedBox(height: 12),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {}, // TODO: Forgot Password
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    AuraPrimaryButton(
                      label: "CONNECT TO AURA",
                      isLoading: loginController.isLoading,
                      icon: Icons.arrow_forward_rounded,
                      onPressed: () => _handleLogin(loginController),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Text(
                "v1.0.0",
                style: TextStyle(
                  color: AppColors.textSecondary.withValues(alpha: 0.5),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: AppColors.surface,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.2),
              width: 1,
            ),
            image: const DecorationImage(
              image: AssetImage('assets/images/icon.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),

        const SizedBox(height: 16),
        Text(
          "Make the Invisible Visible.",
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Future<void> _handleLogin(LoginController controller) async {
    FocusScope.of(context).unfocus();

    try {
      final response = await controller.signIn(
        _emailController.text,
        _passwordController.text,
      );

      if (!mounted) return;
      if (response != null) {
        if (response.isFirstAccess) {
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.firstAccess,
            arguments: _emailController.text,
          );
        } else if (!response.isSettingsConfigured) {
          Navigator.pushReplacementNamed(context, AppRoutes.companySetup);
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        }
      }
    } catch (e) {
      if (mounted) {
        UiMessageHandler.handle(context, e);
      }
    }
  }
}
