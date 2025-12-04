import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuario_model.dart';
import '../utils/constants.dart';

// Servicio de persistencia local - JonthanAyala
class StorageService {
  // Guardar sesión de usuario
  Future<void> guardarSesion(Usuario usuario) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.keyUserId, usuario.id);
      await prefs.setString(AppConstants.keyUserEmail, usuario.email);
      await prefs.setString(AppConstants.keyUserNombre, usuario.nombre);
      await prefs.setString(AppConstants.keyUserRol, usuario.rol);
      await prefs.setBool(AppConstants.keyIsLoggedIn, true);
    } catch (e) {
      throw Exception('Error al guardar sesión: ${e.toString()}');
    }
  }

  // Obtener sesión guardada
  Future<Map<String, String>?> obtenerSesion() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(AppConstants.keyIsLoggedIn) ?? false;

      if (isLoggedIn) {
        return {
          'id': prefs.getString(AppConstants.keyUserId) ?? '',
          'email': prefs.getString(AppConstants.keyUserEmail) ?? '',
          'nombre': prefs.getString(AppConstants.keyUserNombre) ?? '',
          'rol': prefs.getString(AppConstants.keyUserRol) ?? '',
        };
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener sesión: ${e.toString()}');
    }
  }

  // Limpiar sesión
  Future<void> limpiarSesion() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.keyUserId);
      await prefs.remove(AppConstants.keyUserEmail);
      await prefs.remove(AppConstants.keyUserNombre);
      await prefs.remove(AppConstants.keyUserRol);
      await prefs.setBool(AppConstants.keyIsLoggedIn, false);
    } catch (e) {
      throw Exception('Error al limpiar sesión: ${e.toString()}');
    }
  }

  // Verificar si hay sesión activa
  Future<bool> haySesionActiva() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(AppConstants.keyIsLoggedIn) ?? false;
    } catch (e) {
      return false;
    }
  }
}
