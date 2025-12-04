import 'package:flutter/material.dart';
import '../models/usuario_model.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

// ViewModel de autenticación - JaimeCAST69
class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final StorageService _storageService = StorageService();

  Usuario? _usuario;
  bool _isLoading = false;
  String? _errorMessage;

  Usuario? get usuario => _usuario;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _usuario != null;

  // Inicializar y verificar sesión guardada
  Future<void> inicializar() async {
    _isLoading = true;
    notifyListeners();

    try {
      final sesion = await _storageService.obtenerSesion();
      if (sesion != null && _authService.isLoggedIn()) {
        _usuario = await _authService.obtenerUsuarioActual();
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _usuario = await _authService.login(email, password);

      if (_usuario != null) {
        await _storageService.guardarSesion(_usuario!);
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _errorMessage = 'Credenciales inválidas';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Registro
  Future<bool> registro({
    required String nombre,
    required String email,
    required String password,
    required String rol,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _usuario = await _authService.registro(
        nombre: nombre,
        email: email,
        password: password,
        rol: rol,
      );

      if (_usuario != null) {
        await _storageService.guardarSesion(_usuario!);
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _errorMessage = 'Error al registrar usuario';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.logout();
      await _storageService.limpiarSesion();
      _usuario = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Limpiar mensaje de error
  void limpiarError() {
    _errorMessage = null;
    notifyListeners();
  }
}
