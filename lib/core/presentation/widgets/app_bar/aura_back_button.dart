import 'package:flutter/material.dart';

import 'package:aura/core/presentation/theme/app_colors.dart';

class AuraBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AuraBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surface,
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.arrow_back_rounded,
            size: 20,
            color: Colors.white,
          ),
          onPressed: onPressed ?? () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}
