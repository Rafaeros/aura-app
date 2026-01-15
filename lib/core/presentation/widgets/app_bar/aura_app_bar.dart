import 'package:flutter/material.dart';

import 'package:aura/core/presentation/theme/app_colors.dart';
import 'package:aura/core/presentation/widgets/app_bar/user_profile_action_button.dart';

class AuraAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData? icon;
  final List<Widget>? actions;
  final Widget? leading;

  const AuraAppBar({
    super.key,
    required this.title,
    this.icon,
    this.actions,
    this.leading,
  });

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 80,
      centerTitle: true,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 5,

      leading: leading ?? _buildDefaultLeading(),

      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 24, color: Colors.white),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
      ),

      actions: actions ?? [UserProfileActionButton()],
    );
  }

  Widget _buildDefaultLeading() {
    const double size = 48.0;

    return Center(
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surface,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1.5,
          ),

          image: const DecorationImage(
            image: AssetImage('assets/images/icon.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
