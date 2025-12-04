import 'package:flutter/material.dart';
import '../models/estadistica_model.dart';
import '../services/api_service.dart';

// ViewModel de estadísticas - JonthanAyala
// Gestiona el estado de las estadísticas obtenidas via Dio
class EstadisticaViewModel extends ChangeNotifier {
  final ApiService _apiService;

  EstadisticaViewModel(this._apiService);

  EstadisticaPaquetes? _estadisticas;
  bool _isLoading = false;
  String? _errorMessage;

  EstadisticaPaquetes? get estadisticas => _estadisticas;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Cargar estadísticas desde API
  Future<void> cargarEstadisticas() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _estadisticas = await _apiService.obtenerEstadisticas();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _estadisticas = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refrescar estadísticas
  Future<void> refrescar() async {
    await cargarEstadisticas();
  }

  // Limpiar datos
  void limpiar() {
    _estadisticas = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
