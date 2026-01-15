import 'package:flutter/material.dart';

import 'package:aura/core/presentation/theme/app_colors.dart';
import 'package:aura/core/presentation/widgets/app_bar/aura_app_bar_action.dart';
import 'package:aura/core/presentation/widgets/app_bar/aura_popup_menu_item.dart';
import 'package:aura/core/services/local_storage_service.dart';

class UserProfileActionButton extends StatelessWidget {
  UserProfileActionButton({super.key});
  final LocalStorageService _storage = LocalStorageService();

  void _handleLogout(BuildContext context) {
    debugPrint("Logout...");
    _storage.clearAllSecure();
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  void _handleProfile(BuildContext context) {
    Navigator.of(context).pushNamed('/users/profile');
  }

  @override
  Widget build(BuildContext context) {
    return AuraAppBarAction(
      child: PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        icon: const Icon(
          Icons.person_rounded,
          size: 20,
          color: AppColors.primary,
        ),

        color: AppColors.surface,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),

        onSelected: (value) {
          switch (value) {
            case 'profile':
              _handleProfile(context);
              break;
            case 'logout':
              _handleLogout(context);
              break;
          }
        },
        itemBuilder:
            (context) => [
              AuraPopupMenuItem<String>(
                value: 'profile',
                icon: Icons.person_rounded,
                label: 'Profile',
              ),

              const PopupMenuDivider(height: 1),

              AuraPopupMenuItem<String>(
                value: 'logout',
                icon: Icons.logout_rounded,
                label: 'Logout',
                iconColor: Colors.redAccent,
                textColor: Colors.redAccent,
              ),
            ],
      ),
    );
  }
}
