import 'dart:io';
import 'package:path_provider/path_provider.dart';

// Servicio de almacenamiento local de fotos - Solución temporal sin Firebase Storage
// NOTA: Este servicio guarda las fotos localmente en el dispositivo
// Para migrar a la nube en el futuro, usar Firebase Storage o servicio similar
class LocalStorageService {
  // Directorio donde se guardan las fotos
  static const String _fotosDirectorio = 'fotos_paquetes';

  // Obtener directorio de documentos de la aplicación
  Future<Directory> _getAppDirectory() async {
    return await getApplicationDocumentsDirectory();
  }

  // Guardar foto localmente y retornar la ruta
  Future<String> guardarFoto(File foto, String paqueteId) async {
    try {
      final appDir = await _getAppDirectory();
      final fotosDir = Directory('${appDir.path}/$_fotosDirectorio');

      // Crear directorio si no existe
      if (!await fotosDir.exists()) {
        await fotosDir.create(recursive: true);
      }

      // Obtener extensión del archivo original
      final extension = foto.path.split('.').last;
      final nombreArchivo = '$paqueteId.$extension';
      final rutaDestino = '${fotosDir.path}/$nombreArchivo';

      // Copiar foto al directorio de la app
      await foto.copy(rutaDestino);

      return rutaDestino;
    } catch (e) {
      throw Exception('Error al guardar foto localmente: ${e.toString()}');
    }
  }

  // Verificar si existe una foto en la ruta especificada
  bool existeFoto(String ruta) {
    final file = File(ruta);
    return file.existsSync();
  }

  // Obtener archivo de foto si existe
  File? obtenerFoto(String ruta) {
    final file = File(ruta);
    return file.existsSync() ? file : null;
  }

  // Eliminar foto del almacenamiento local
  Future<void> eliminarFoto(String ruta) async {
    try {
      final file = File(ruta);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      throw Exception('Error al eliminar foto: ${e.toString()}');
    }
  }

  // Limpiar todas las fotos (útil para mantenimiento)
  Future<void> limpiarTodasLasFotos() async {
    try {
      final appDir = await _getAppDirectory();
      final fotosDir = Directory('${appDir.path}/$_fotosDirectorio');

      if (await fotosDir.exists()) {
        await fotosDir.delete(recursive: true);
      }
    } catch (e) {
      throw Exception('Error al limpiar fotos: ${e.toString()}');
    }
  }

  // Obtener tamaño total de fotos almacenadas (en bytes)
  Future<int> obtenerTamanoTotal() async {
    try {
      final appDir = await _getAppDirectory();
      final fotosDir = Directory('${appDir.path}/$_fotosDirectorio');

      if (!await fotosDir.exists()) {
        return 0;
      }

      int tamanoTotal = 0;
      await for (var entity in fotosDir.list(recursive: true)) {
        if (entity is File) {
          tamanoTotal += await entity.length();
        }
      }

      return tamanoTotal;
    } catch (e) {
      return 0;
    }
  }
}
