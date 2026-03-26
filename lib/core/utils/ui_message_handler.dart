import 'package:aura/core/utils/app_notifications.dart';
import 'package:flutter/material.dart';

import 'package:aura/core/exception/app_exception.dart';

class UiMessageHandler {
  static void handle(BuildContext context, Object error) {
    if (error is AppException) {
      switch (error.severity) {
        case ErrorSeverity.INFO:
          AppNotifications.showInfo(context: context, message: error.message);
          break;
        case ErrorSeverity.WARNING:
          AppNotifications.showWarning(context: context, message: error.message);
          break;
        case ErrorSeverity.ERROR:
          AppNotifications.showError(context: context, message: error.message);
          break;
      }
    } else {
      AppNotifications.showError(
        context: context, 
        message: 'Ocorreu um erro inesperado: ${error.toString()}',
      );
    }
  }
}
