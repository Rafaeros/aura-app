import 'package:aura/features/auth/presentation/controllers/splash_controller.dart';
import 'package:aura/features/telemetry/data/services/mqtt_service.dart';
import 'package:aura/features/telemetry/data/services/telemetry_service.dart';
import 'package:aura/features/telemetry/presentation/controllers/telemetry_history_controller.dart';
import 'package:aura/features/telemetry/presentation/controllers/telemetry_sync_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

// --- CORE ---
import 'package:aura/core/client/dio_client.dart';
import 'package:aura/core/routes/app_routes.dart';
import 'package:aura/core/presentation/theme/app_colors.dart';

// --- AUTH ---
import 'package:aura/features/auth/data/services/auth_api_service.dart';
import 'package:aura/features/auth/data/repositories/auth_repository.dart';
import 'package:aura/features/auth/presentation/controllers/login_controller.dart';

// --- DEVICES ---
import 'package:aura/features/devices/data/services/device_api_service.dart';
import 'package:aura/features/devices/data/repository/device_repository.dart';
import 'package:aura/features/devices/presentation/controllers/device_controller.dart';

// --- PROFILE ---
import 'package:aura/features/profile/data/service/profile_service.dart';
import 'package:aura/features/profile/data/repository/profile_repository.dart';
import 'package:aura/features/profile/presentation/controller/profile_controller.dart';

// --- COMPANY ---
import 'package:aura/features/company/data/service/company_settings_service.dart';
import 'package:aura/features/company/data/repository/company_settings_repository.dart';
import 'package:aura/features/company/presentation/controllers/company_settings_controller.dart';

// --- TELEMETRY ---
import 'package:aura/features/telemetry/presentation/controllers/telemetry_connection_controller.dart';
import 'package:aura/features/telemetry/data/repositories/telemetry_repository.dart';

// --- OTHERS ---
import 'package:aura/features/home/presentation/controllers/home_controller.dart';
import 'package:aura/features/ble/presentation/controllers/ble_controller.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dioClient = DioClient();

  runApp(
    MultiProvider(
      providers: [
        // =========================================================
        // 1. Infrastructure (Globals)
        // =========================================================
        Provider<Dio>.value(value: dioClient.dio),

        // MQTT Service (Singleton Instance)
        // Needs to be provided so controllers can find it
        Provider<MqttService>(create: (_) => MqttService.instance),

        // =========================================================
        // 2. DATA LAYER (Services & Repositories)
        // =========================================================

        // --- Auth ---
        ProxyProvider<Dio, AuthApiService>(
          update: (_, dio, __) => AuthApiService(dio),
        ),
        ProxyProvider<AuthApiService, AuthRepository>(
          update: (_, service, __) => AuthRepository(service),
        ),

        // --- Devices ---
        ProxyProvider<Dio, DeviceApiService>(
          update: (_, dio, __) => DeviceApiService(dio),
        ),
        ProxyProvider<DeviceApiService, DeviceRepository>(
          update: (_, service, __) => DeviceRepository(service),
        ),

        // --- Profile ---
        ProxyProvider<Dio, ProfileApiService>(
          update: (_, dio, __) => ProfileApiService(dio),
        ),
        ProxyProvider<ProfileApiService, ProfileRepository>(
          update: (_, service, __) => ProfileRepository(service),
        ),

        // --- Company Settings ---
        ProxyProvider<Dio, CompanySettingsApiService>(
          update: (_, dio, __) => CompanySettingsApiService(dio),
        ),
        ProxyProvider<CompanySettingsApiService, CompanySettingsRepository>(
          update: (_, service, __) => CompanySettingsRepository(service),
        ),

        // --- Telemetry (Updated) ---
        // 1. API Service (assuming you have TelemetryApiService, otherwise adapt to Dio)
        ProxyProvider<Dio, TelemetryApiService>(
          update: (_, dio, __) => TelemetryApiService(dio),
        ),
        // 2. Repository
        ProxyProvider<TelemetryApiService, TelemetryRepository>(
          update: (_, service, __) => TelemetryRepository(service),
        ),

        // =========================================================
        // 3. BACKGROUND WORKERS (Logic Controllers)
        // =========================================================

        // This is the "Magic" part.
        // It injects MqttService + DeviceRepo + TelemetryRepo into the SyncController.
        // lazy: false ensures it starts listening immediately when the app runs.
        ProxyProvider3<
          MqttService,
          DeviceRepository,
          TelemetryRepository,
          TelemetrySyncController
        >(
          update:
              (_, mqtt, devRepo, telRepo, __) =>
                  TelemetrySyncController(mqtt, devRepo, telRepo),
          lazy: false,
        ),

        // =========================================================
        // 4. PRESENTATION LAYER (UI Controllers)
        // =========================================================
        ChangeNotifierProvider(create: (_) => SplashController()),

        ChangeNotifierProvider(
          create: (context) => LoginController(context.read<AuthRepository>()),
        ),

        ChangeNotifierProvider(
          create:
              (context) => DeviceController(context.read<DeviceRepository>()),
        ),

        ChangeNotifierProvider(
          create:
              (context) => ProfileController(context.read<ProfileRepository>()),
        ),

        ChangeNotifierProvider(
          create:
              (context) => CompanySettingsController(
                context.read<CompanySettingsRepository>(),
              ),
        ),

        // Controllers without API dependency
        ChangeNotifierProvider(create: (_) => HomeController()),
        ChangeNotifierProvider(create: (_) => BleController()),

        // Telemetry UI Controller (For Connection Status Screen)
        // Removed DeviceRepository dependency as discussed in refactoring
        // =========================================================
        // --- TELEMETRY CONTROLLERS (ATUALIZADO) ---
        // =========================================================

        // 1. Controller de Conexão (Botão Conectar/Desconectar)
        ChangeNotifierProvider(
          create:
              (context) => TelemetryConnectionController(
                context.read<TelemetryRepository>(),
              ),
        ),

        // 2. Controller de Histórico (Lista de Logs Paginada)
        ChangeNotifierProvider(
          create:
              (context) => TelemetryHistoryController(
                context.read<TelemetryRepository>(),
              ),
        ),
      ],
      child: const AuraApp(),
    ),
  );
}

class AuraApp extends StatelessWidget {
  const AuraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Aura',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          surface: AppColors.surface,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
