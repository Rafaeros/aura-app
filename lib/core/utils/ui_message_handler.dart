import 'package:flutter/material.dart';
import 'package:aura/core/exception/app_exception.dart';
import 'package:aura/core/presentation/theme/app_colors.dart';

class UiMessageHandler {
  static void handle(BuildContext context, Object error) {
    String message = "An unexpected error occurred.";
    Color color = Colors.red;
    IconData icon = Icons.error_outline;

    if (error is AppException) {
      message = error.message;

      switch (error.severity) {
        case ErrorSeverity.INFO:
          color = AppColors.info;
          icon = Icons.info_outline;
          break;
        case ErrorSeverity.WARNING:
          color = AppColors.warning;
          icon = Icons.warning_amber_rounded;
          break;
        case ErrorSeverity.ERROR:
          color = AppColors.error;
          icon = Icons.cancel_outlined;
          break;
      }
    } else {
      message = error.toString();
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: color,
        showCloseIcon: true,
        closeIconColor: Colors.white,
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
