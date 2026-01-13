import 'package:flutter/material.dart';

import 'package:aura/core/presentation/theme/app_colors.dart';

class AuraPopupMenuItem<T> extends PopupMenuItem<T> {
  AuraPopupMenuItem({
    super.key,
    required super.value,
    super.onTap,
    required IconData icon,
    required String label,

    Color? iconColor,
    Color? textColor,
  }) : super(
         child: Row(
           children: [
             Icon(icon, color: iconColor ?? AppColors.primary, size: 20),
             const SizedBox(width: 12),
             Text(
               label,
               style: TextStyle(
                 color: textColor ?? Colors.white,
                 fontWeight: FontWeight.w500,
               ),
             ),
           ],
         ),
       );
}
