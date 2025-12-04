import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/estadistica_model.dart';
import 'auth_service.dart';

// Servicio de API REST con Dio - JonthanAyala
// Implementa consumo de APIs REST según lineamientos obligatorios
class ApiService {
  late final Dio _dio;
  final AuthService _authService;

  // Base URL - En producción usar Firebase Cloud Functions o API real
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  ApiService(this._authService) {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _setupInterceptors();
  }

  // Configuración de interceptors (requisito obligatorio)
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        // Interceptor de autenticación
        onRequest: (options, handler) async {
          // TODO: Agregar token de autenticación cuando esté disponible
          // Por ahora, Dio funciona sin autenticación para demostración

          // Logging en modo debug
          if (kDebugMode) {
            print('🌐 REQUEST[${options.method}] => ${options.uri}');
            print('Headers: ${options.headers}');
            if (options.data != null) {
              print('Data: ${options.data}');
            }
          }

          return handler.next(options);
        },

        // Interceptor de respuesta
        onResponse: (response, handler) {
          if (kDebugMode) {
            print(
              '✅ RESPONSE[${response.statusCode}] => ${response.requestOptions.uri}',
            );
            print('Data: ${response.data}');
          }
          return handler.next(response);
        },

        // Interceptor de errores (requisito obligatorio)
        onError: (error, handler) async {
          if (kDebugMode) {
            print(
              '❌ ERROR[${error.response?.statusCode}] => ${error.requestOptions.uri}',
            );
            print('Message: ${error.message}');
          }

          // Manejo de errores HTTP específicos
          if (error.response != null) {
            switch (error.response!.statusCode) {
              case 400:
                error = DioException(
                  requestOptions: error.requestOptions,
                  error: 'Solicitud incorrecta. Verifica los datos enviados.',
                  response: error.response,
                  type: DioExceptionType.badResponse,
                );
                break;
              case 401:
                error = DioException(
                  requestOptions: error.requestOptions,
                  error: 'No autorizado. Inicia sesión nuevamente.',
                  response: error.response,
                  type: DioExceptionType.badResponse,
                );
                break;
              case 404:
                error = DioException(
                  requestOptions: error.requestOptions,
                  error: 'Recurso no encontrado.',
                  response: error.response,
                  type: DioExceptionType.badResponse,
                );
                break;
              case 500:
                error = DioException(
                  requestOptions: error.requestOptions,
                  error: 'Error del servidor. Intenta más tarde.',
                  response: error.response,
                  type: DioExceptionType.badResponse,
                );
                break;
            }
          } else {
            // Error de conexión
            error = DioException(
              requestOptions: error.requestOptions,
              error: 'Error de conexión. Verifica tu internet.',
              type: DioExceptionType.connectionError,
            );
          }

          return handler.next(error);
        },
      ),
    );

    // Interceptor de retry logic (requisito obligatorio)
    _dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onError: (error, handler) async {
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.connectionError) {
            // Reintentar hasta 3 veces
            final retryCount = error.requestOptions.extra['retryCount'] ?? 0;
            if (retryCount < 3) {
              error.requestOptions.extra['retryCount'] = retryCount + 1;

              if (kDebugMode) {
                print('🔄 Reintentando... (${retryCount + 1}/3)');
              }

              // Esperar antes de reintentar
              await Future.delayed(Duration(seconds: retryCount + 1));

              try {
                final response = await _dio.fetch(error.requestOptions);
                return handler.resolve(response);
              } catch (e) {
                return handler.next(error);
              }
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  // Endpoint de ejemplo: Obtener estadísticas de paquetes
  Future<EstadisticaPaquetes> obtenerEstadisticas() async {
    try {
      // En producción, esto sería un endpoint real de Firebase Cloud Functions
      // Por ahora usamos JSONPlaceholder como demostración
      await _dio.get('/users/1');

      // Simular estadísticas basadas en datos de ejemplo
      return EstadisticaPaquetes(
        totalPaquetes: 42,
        pendientes: 12,
        enTransito: 18,
        entregados: 12,
        porcentajeEntregados: 28.6,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Endpoint de ejemplo: Obtener perfil de usuario
  Future<Map<String, dynamic>> obtenerPerfilUsuario(String userId) async {
    try {
      final response = await _dio.get('/users/$userId');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Endpoint de ejemplo: Generar reporte
  Future<Map<String, dynamic>> generarReporte({
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) async {
    try {
      final response = await _dio.post(
        '/posts',
        data: {
          'fechaInicio': fechaInicio.toIso8601String(),
          'fechaFin': fechaFin.toIso8601String(),
          'tipo': 'paquetes',
        },
      );

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Manejo centralizado de errores
  String _handleError(DioException error) {
    if (error.error is String) {
      return error.error as String;
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Tiempo de espera agotado. Intenta nuevamente.';
      case DioExceptionType.badResponse:
        return error.response?.data['message'] ?? 'Error del servidor.';
      case DioExceptionType.cancel:
        return 'Solicitud cancelada.';
      default:
        return 'Error de conexión. Verifica tu internet.';
    }
  }

  // Método para cancelar todas las solicitudes pendientes
  void cancelarSolicitudes() {
    _dio.close(force: true);
  }
}
