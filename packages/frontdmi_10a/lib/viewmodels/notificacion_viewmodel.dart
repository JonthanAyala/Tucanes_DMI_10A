import 'package:flutter/material.dart';
import '../models/notificacion_model.dart';
import '../services/notificacion_firestore_service.dart';

// ViewModel de bandeja de notificaciones - JonthanAyala
class NotificacionViewModel extends ChangeNotifier {
  final NotificacionFirestoreService _service = NotificacionFirestoreService();

  List<Notificacion> _notificaciones = [];
  int _noLeidasCount = 0;
  bool _isLoading = false;
  String? _errorMessage;
  String? _currentUserId; // Almacenar userId para acciones posteriores

  List<Notificacion> get notificaciones => _notificaciones;
  int get noLeidasCount => _noLeidasCount;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Escuchar notificaciones del usuario
  Stream<List<Notificacion>>? _notificacionesStream;

  void inicializarStream(String userId) {
    _currentUserId = userId;
    _notificacionesStream = _service.obtenerNotificacionesUsuario(userId);
    _notificacionesStream!.listen(
      (notificaciones) {
        _notificaciones = notificaciones;
        _noLeidasCount = notificaciones.where((n) => !n.leida).length;
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = error.toString();
        notifyListeners();
      },
    );
  }

  // Recargar notificaciones (Pull-to-refresh)
  Future<void> recargarNotificaciones(String userId) async {
    _isLoading = true;
    notifyListeners();

    // Simular un pequeño delay para UX y reiniciar el stream
    await Future.delayed(const Duration(milliseconds: 500));
    inicializarStream(userId);

    _isLoading = false;
    notifyListeners();
  }

  // Marcar como leída
  Future<void> marcarComoLeida(String notificacionId) async {
    if (_currentUserId == null) return;
    try {
      await _service.marcarComoLeida(_currentUserId!, notificacionId);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Marcar todas como leídas
  Future<void> marcarTodasComoLeidas(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _service.marcarTodasComoLeidas(userId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Eliminar notificación
  Future<bool> eliminarNotificacion(String notificacionId) async {
    if (_currentUserId == null) return false;
    try {
      await _service.eliminarNotificacion(_currentUserId!, notificacionId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Eliminar todas
  Future<bool> eliminarTodas(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _service.eliminarTodasNotificaciones(userId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Limpiar notificaciones antiguas
  Future<void> limpiarAntiguas(String userId) async {
    try {
      await _service.limpiarNotificacionesAntiguas(userId);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Limpiar error
  void limpiarError() {
    _errorMessage = null;
    notifyListeners();
  }
}
