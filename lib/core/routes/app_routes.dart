import 'package:flutter/material.dart';

import 'package:aura/features/auth/presentation/screens/company_initial_setup_screen.dart';
import 'package:aura/features/auth/presentation/screens/first_access_screen.dart';
import 'package:aura/features/auth/presentation/screens/login_screen.dart';
import 'package:aura/features/auth/presentation/screens/splash_screen.dart';
import 'package:aura/features/auth/presentation/screens/welcome_screen.dart';
import 'package:aura/features/company/data/model/company_settings_model.dart';
import 'package:aura/features/company/presentation/screens/company_settings_edit_screen.dart';
import 'package:aura/features/devices/presentation/screens/add_device_screen.dart';
import 'package:aura/features/devices/presentation/screens/device_details_screen.dart';
import 'package:aura/features/devices/presentation/screens/devices_screen.dart';
import 'package:aura/features/home/presentation/screens/home_screen.dart';
import 'package:aura/features/profile/presentation/screens/user_profile_screen.dart';

class AppRoutes {
  static const splash = '/';

  static const login = '/login';

  static const welcome = '/welcome';
  static const firstAccess = '/first-access';
  static const companySetup = '/company/setup';

  static const home = "/home";

  static const profile = "/users/profile";

  static const companySettingsEdit = "/company/settings/edit";
  static const deviceList = '/devices';
  static const deviceDetails = '/devices/details';
  static const deviceEdit = '/devices/edit';
  static const addDevice = '/devices/add';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case AppRoutes.welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case AppRoutes.firstAccess:
        return MaterialPageRoute(
          builder:
              (_) => FirstAccessScreen(email: settings.arguments as String),
        );

      case AppRoutes.companySetup:
        return MaterialPageRoute(
          builder: (_) => const CompanyInitialSetupScreen(),
        );

      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      case AppRoutes.companySettingsEdit:
        final args = settings.arguments as CompanySettingsModel?;
        return MaterialPageRoute(
          builder: (_) => CompanySettingsEditScreen(currentSettings: args),
        );

      case AppRoutes.deviceList:
        return MaterialPageRoute(builder: (_) => const DevicesScreen());

      case AppRoutes.addDevice:
        return MaterialPageRoute(builder: (_) => const AddDeviceScreen());

      case AppRoutes.deviceDetails:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => DeviceDetailsScreen(deviceID: args['id']),
        );

      default:
        return MaterialPageRoute(
          builder:
              (_) =>
                  const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
