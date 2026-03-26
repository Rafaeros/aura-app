import 'package:aura/core/exception/app_exception.dart';
import 'package:aura/core/utils/app_notifications.dart';
import 'package:dio/dio.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response != null && err.response?.data != null) {
      final data = err.response!.data;
      // Check if the error body matches the ApiResponse pattern
      if (data is Map<String, dynamic> && data.containsKey('severity')) {
        final exception = AppException.fromJson(
          data,
          err.response!.statusCode ?? 500,
        );
        
        AppNotifications.showError(message: exception.message);

        // Pass the custom AppException into the DioException's error property
        return handler.next(
          DioException(
            requestOptions: err.requestOptions,
            response: err.response,
            type: err.type,
            error: exception,
            message: exception.message,
          ),
        );
      }
    }
    
    // In case there is no connection or backend is completely unreachable
    if (err.type == DioExceptionType.connectionTimeout || 
        err.type == DioExceptionType.receiveTimeout || 
        err.type == DioExceptionType.connectionError) {
       final exception = AppException(
         message: 'Não foi possível conectar ao servidor. Verifique sua conexão.',
         severity: ErrorSeverity.ERROR,
         statusCode: 503,
       );
       
       AppNotifications.showError(message: exception.message);
       
       return handler.next(
          DioException(
            requestOptions: err.requestOptions,
            type: err.type,
            error: exception,
            message: exception.message,
          ),
        );
    }

    AppNotifications.showError(message: err.message ?? 'Ocorreu um erro inesperado.');
    return handler.next(err);
  }
}
