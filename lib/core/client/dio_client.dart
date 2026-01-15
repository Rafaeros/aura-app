import 'package:aura/core/routes/app_routes.dart';
import 'package:aura/core/services/local_storage_service.dart';
import 'package:aura/main.dart';
import 'package:dio/dio.dart';

class DioClient {
  late Dio dio;
  final LocalStorageService _storage = LocalStorageService();

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://192.168.0.104:8090',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.readSecure(
            LocalStorageService.keyJwtToken,
          );
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },

        onError: (DioException e, handler) async {
          final statusCode = e.response?.statusCode;
          final bool ignoreAuthInterceptor =
              e.requestOptions.extra['ignoreAuth'] == true;
          if ((statusCode == 401 || statusCode == 403) &&
              !ignoreAuthInterceptor) {
            await _storage.clearAllSecure();

            navigatorKey.currentState?.pushNamedAndRemoveUntil(
              AppRoutes.login,
              (route) => false,
            );
          }

          return handler.next(e);
        },
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
      ),
    );
  }
}
