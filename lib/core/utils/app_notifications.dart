import 'package:aura/main.dart';
import 'package:aura/core/presentation/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class AppNotifications {
  static void showSuccess({
    BuildContext? context,
    required String message,
    String? title,
  }) {
    final targetContext = context ?? navigatorKey.currentContext;
    if (targetContext == null) return;

    toastification.show(
      context: targetContext,
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      primaryColor: AppColors.success,
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      icon: const Icon(Icons.check_circle_rounded, color: AppColors.success),
      title: Text(
        title ?? 'Sucesso',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      description: Text(message, style: const TextStyle(color: AppColors.textSecondary)),
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 3),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: highModeShadow,
    );
  }

  static void showError({
    BuildContext? context,
    required String message,
    String? title,
  }) {
    final targetContext = context ?? navigatorKey.currentContext;
    if (targetContext == null) return;

    toastification.show(
      context: targetContext,
      type: ToastificationType.error,
      style: ToastificationStyle.flat,
      primaryColor: AppColors.error,
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      icon: const Icon(Icons.error_rounded, color: AppColors.error),
      title: Text(
        title ?? 'Erro',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      description: Text(message, style: const TextStyle(color: AppColors.textSecondary)),
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 4),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: highModeShadow,
    );
  }

  static void showWarning({
    BuildContext? context,
    required String message,
    String? title,
  }) {
    final targetContext = context ?? navigatorKey.currentContext;
    if (targetContext == null) return;

    toastification.show(
      context: targetContext,
      type: ToastificationType.warning,
      style: ToastificationStyle.flat,
      primaryColor: AppColors.warning,
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      icon: const Icon(Icons.warning_rounded, color: AppColors.warning),
      title: Text(
        title ?? 'Aviso',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      description: Text(message, style: const TextStyle(color: AppColors.textSecondary)),
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 4),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: highModeShadow,
    );
  }

  static void showInfo({
    BuildContext? context,
    required String message,
    String? title,
  }) {
    final targetContext = context ?? navigatorKey.currentContext;
    if (targetContext == null) return;

    toastification.show(
      context: targetContext,
      type: ToastificationType.info,
      style: ToastificationStyle.flat,
      primaryColor: AppColors.info,
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      icon: const Icon(Icons.info_rounded, color: AppColors.info),
      title: Text(
        title ?? 'Informação',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      description: Text(message, style: const TextStyle(color: AppColors.textSecondary)),
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 3),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: highModeShadow,
    );
  }
}
