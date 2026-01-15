import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:aura/core/presentation/theme/app_colors.dart';
import 'package:aura/core/presentation/widgets/app_bar/aura_app_bar.dart';
import 'package:aura/core/presentation/widgets/app_bar/aura_back_button.dart';
import 'package:aura/core/presentation/widgets/layout/aura_card.dart';
import 'package:aura/core/routes/app_routes.dart';
import 'package:aura/core/services/local_storage_service.dart';
import 'package:aura/core/utils/format_utils.dart';
import 'package:aura/core/utils/ui_message_handler.dart';
import 'package:aura/features/profile/presentation/controller/profile_controller.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final LocalStorageService _storage = LocalStorageService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfile();
    });
  }

  Future<void> _loadProfile() async {
    try {
      await context.read<ProfileController>().fetchUserProfile();
    } catch (e) {
      if (mounted) UiMessageHandler.handle(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProfileController>();
    final user = controller.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AuraAppBar(
        icon: Icons.person,
        title: "Profile",
        leading: AuraBackButton(),
        actions: [],
      ),
      body:
          controller.isLoading
              ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
              : user == null
              ? _buildErrorState(controller)
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildHeader(user.username, user.email),

                    const SizedBox(height: 32),
                    _buildSectionHeader("Personal Data"),
                    AuraCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildInfoRow(
                            "Username",
                            user.username,
                            Icons.person,
                          ),
                          const Divider(height: 24, color: Colors.white10),
                          _buildInfoRow("E-mail", user.email, Icons.email),
                        ],
                      ),
                    ),

                    if (user.company != null) ...[
                      const SizedBox(height: 32),
                      _buildSectionHeader("My Company"),
                      AuraCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow(
                              "Company Name",
                              user.company!.name,
                              Icons.business,
                            ),
                            const Divider(height: 24, color: Colors.white10),
                            _buildInfoRow(
                              "CNPJ",
                              FormatUtils.formatCNPJ(user.company!.cnpj),
                              Icons.badge,
                            ),

                            if (user.company!.settings != null) ...[
                              const SizedBox(height: 24),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.05),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Row(
                                          children: [
                                            Icon(
                                              Icons.hub,
                                              size: 16,
                                              color: AppColors.primary,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              "INTEGRATIONS SETUP",
                                              style: TextStyle(
                                                color: AppColors.primary,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.0,
                                              ),
                                            ),
                                          ],
                                        ),

                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            onTap: () async {
                                              final result =
                                                  await Navigator.pushNamed(
                                                    context,
                                                    AppRoutes
                                                        .companySettingsEdit,
                                                    arguments:
                                                        user.company!.settings,
                                                  );

                                              if (result == true && mounted) {
                                                _loadProfile();
                                              }
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                4.0,
                                              ),
                                              child: Icon(
                                                Icons.edit_rounded,
                                                size: 18,
                                                color: AppColors.primary
                                                    .withValues(alpha: 0.8),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),

                                    _buildTechField(
                                      "MQTT Host",
                                      user.company!.settings!.mqttHost,
                                    ),
                                    const Divider(
                                      height: 16,
                                      color: Colors.white10,
                                    ),

                                    _buildTechField(
                                      "MQTT Port",
                                      user.company!.settings!.mqttPort
                                          .toString(),
                                    ),
                                    const Divider(
                                      height: 16,
                                      color: Colors.white10,
                                    ),

                                    _buildTechField(
                                      "MQTT User",
                                      user.company!.settings!.mqttUsername,
                                      isSecret: true,
                                    ),
                                    const Divider(
                                      height: 16,
                                      color: Colors.white10,
                                    ),

                                    _buildTechField(
                                      "MQTT Password",
                                      user.company!.settings!.mqttPassword ??
                                          '',
                                      isSecret: true,
                                    ),
                                    const Divider(
                                      height: 16,
                                      color: Colors.white10,
                                    ),

                                    _buildTechField(
                                      "Everynet API Key",
                                      user
                                          .company!
                                          .settings!
                                          .everynetAccessToken,
                                      isSecret: true,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 40),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _storage.clearAllSecure();
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            AppRoutes.splash,
                            (_) => false,
                          );
                        },
                        icon: const Icon(Icons.logout, color: Colors.redAccent),
                        label: const Text(
                          "Logout",
                          style: TextStyle(color: Colors.redAccent),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(
                            color: Colors.redAccent.withValues(alpha: 0.5),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
    );
  }

  Widget _buildTechField(String label, String value, {bool isSecret = false}) {
    final displayValue = isSecret ? "••••••••••••" : value;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(width: 16),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    displayValue,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color:
                          isSecret
                              ? AppColors.textSecondary.withValues(alpha: 0.7)
                              : AppColors.textPrimary,
                      fontFamily: 'monospace',
                      fontSize: 13,
                      letterSpacing: isSecret ? 2.0 : 0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: value));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("$label copied!"),
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: AppColors.surface,
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.copy_rounded,
                      size: 14,
                      color: AppColors.primary.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String name, String email) {
    return Column(
      children: [
        Container(
          height: 90,
          width: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surface,
            border: Border.all(color: AppColors.primary, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.2),
                blurRadius: 20,
              ),
            ],
          ),
          child: const Icon(
            Icons.person_rounded,
            size: 45,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          email,
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.textSecondary.withValues(alpha: 0.5),
          size: 20,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 2),
              SelectableText(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(ProfileController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
          const SizedBox(height: 16),
          const Text(
            "Error fetching user profile",
            style: TextStyle(color: Colors.white),
          ),
          TextButton(
            onPressed: () => controller.fetchUserProfile(),
            child: const Text("Try again"),
          ),
        ],
      ),
    );
  }
}
