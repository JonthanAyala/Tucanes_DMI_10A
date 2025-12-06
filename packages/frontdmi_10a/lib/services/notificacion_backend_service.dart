import 'package:dio/dio.dart';

/// Servicio para comunicación con backend de notificaciones
/// @author JonthanAyala
class NotificacionBackendService {
  final Dio _dio;

  // URL del backend - CAMBIAR según tu configuración
  static const String _baseUrl =
      'http://paqueteria.us-east-1.elasticbeanstalk.com/api/notificaciones';
  //static const String _baseUrl = 'http://localhost:8080/api/notificaciones';

  NotificacionBackendService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: _baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {'Content-Type': 'application/json'},
        ),
      );

  /// CASO 1: Notificar que un paquete fue tomado por un repartidor
  Future<bool> notificarPaqueteTomado({
    required String paqueteId,
    required String clienteId,
    required String repartidorId,
  }) async {
    try {
      final response = await _dio.post(
        '/paquete-tomado',
        data: {
          'paqueteId': paqueteId,
          'clienteId': clienteId,
          'repartidorId': repartidorId,
        },
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      print('Error al notificar paquete tomado: ${e.message}');
      // No lanzar error, solo registrar
      return false;
    } catch (e) {
      print('Error inesperado al notificar paquete tomado: $e');
      return false;
    }
  }

  /// CASO 2: Notificar nuevo paquete disponible a repartidores
  Future<bool> notificarNuevoPaquete({required String paqueteId}) async {
    try {
      final response = await _dio.post(
        '/nuevo-paquete',
        data: {'paqueteId': paqueteId},
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      print('Error al notificar nuevo paquete: ${e.message}');
      return false;
    } catch (e) {
      print('Error inesperado al notificar nuevo paquete: $e');
      return false;
    }
  }

  /// CASO 3: Notificar que un paquete fue entregado
  Future<bool> notificarPaqueteEntregado({
    required String paqueteId,
    required String clienteId,
  }) async {
    try {
      final response = await _dio.post(
        '/paquete-entregado',
        data: {'paqueteId': paqueteId, 'clienteId': clienteId},
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      print('Error al notificar paquete entregado: ${e.message}');
      return false;
    } catch (e) {
      print('Error inesperado al notificar paquete entregado: $e');
      return false;
    }
  }

  /// Verificar salud del backend
  Future<bool> verificarConexion() async {
    try {
      final response = await _dio.get('/health');
      return response.statusCode == 200;
    } catch (e) {
      print('Backend no disponible: $e');
      return false;
    }
  }
}
