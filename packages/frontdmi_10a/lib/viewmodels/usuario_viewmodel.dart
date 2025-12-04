import 'package:flutter/material.dart';
import '../models/usuario_model.dart';
import '../services/usuario_service.dart';
import '../services/auth_service.dart';

// ViewModel de gestión de usuarios - JonthanAyala
// Solo para administradores
class UsuarioViewModel extends ChangeNotifier {
  final UsuarioService _usuarioService = UsuarioService();
  final AuthService _authService = AuthService();

  List<Usuario> _usuarios = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _filtroRol = 'todos';

  List<Usuario> get usuarios => _usuarios;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get filtroRol => _filtroRol;

  // Cargar todos los usuarios
  Future<void> cargarUsuarios() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_filtroRol == 'todos') {
        _usuarios = await _usuarioService.obtenerTodosUsuarios();
      } else {
        _usuarios = await _usuarioService.obtenerUsuariosPorRol(_filtroRol);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Filtrar por rol
  void filtrarPorRol(String rol) {
    _filtroRol = rol;
    notifyListeners(); // Notificar cambio inmediato
    cargarUsuarios();
  }

  // Buscar usuarios
  Future<void> buscarUsuarios(String query) async {
    if (query.isEmpty) {
      cargarUsuarios();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _usuarios = await _usuarioService.buscarUsuarios(query);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Crear usuario (admin crea manualmente)
  Future<bool> crearUsuario({
    required String nombre,
    required String email,
    required String password,
    required String rol,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Usar el servicio de autenticación para crear el usuario
      final usuario = await _authService.registro(
        nombre: nombre,
        email: email,
        password: password,
        rol: rol,
      );

      if (usuario != null) {
        await cargarUsuarios();
        return true;
      }

      _errorMessage = 'Error al crear usuario';
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Actualizar usuario
  Future<bool> actualizarUsuario(Usuario usuario) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _usuarioService.actualizarUsuario(usuario);
      if (success) {
        await cargarUsuarios();
      }
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Eliminar usuario
  Future<bool> eliminarUsuario(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _usuarioService.eliminarUsuario(id);
      if (success) {
        await cargarUsuarios();
      }
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cambiar rol de usuario
  Future<bool> cambiarRol(String userId, String nuevoRol) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _usuarioService.cambiarRol(userId, nuevoRol);
      if (success) {
        await cargarUsuarios();
      }
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Limpiar error
  void limpiarError() {
    _errorMessage = null;
    notifyListeners();
  }
}
