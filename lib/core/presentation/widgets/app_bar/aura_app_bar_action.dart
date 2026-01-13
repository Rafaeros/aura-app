import 'package:flutter/material.dart';

import 'package:aura/core/presentation/theme/app_colors.dart';

class AuraAppBarAction extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  final Color? backgroundColor;
  final Color? borderColor;

  const AuraAppBarAction({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(right: 16),
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor ?? AppColors.surface,
            border: Border.all(
              color: borderColor ?? Colors.white.withValues(alpha: 0.1),
            ),
          ),
          child: ClipOval(child: child),
        ),
      ),
    );
  }
}
