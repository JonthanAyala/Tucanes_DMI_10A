import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ubicacion_model.dart';

// Servicio de geolocalización - BojitaNoir
class LocationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Verificar y solicitar permisos de ubicación
  Future<bool> checkPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  // Obtener ubicación actual
  Future<Ubicacion?> getCurrentLocation() async {
    try {
      final hasPermission = await checkPermissions();
      if (!hasPermission) return null;

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return Ubicacion(
        latitud: position.latitude,
        longitud: position.longitude,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Error al obtener ubicación: ${e.toString()}');
    }
  }

  // Escuchar cambios de ubicación
  Stream<Ubicacion> watchLocation() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Actualizar cada 10 metros
      ),
    ).map((position) {
      return Ubicacion(
        latitud: position.latitude,
        longitud: position.longitude,
        timestamp: DateTime.now(),
      );
    });
  }

  // Actualizar ubicación del repartidor en Firestore
  Future<void> updateRepartidorLocation(
    String repartidorId,
    Ubicacion ubicacion,
  ) async {
    try {
      await _firestore
          .collection('ubicaciones_repartidores')
          .doc(repartidorId)
          .set(ubicacion.toJson());
    } catch (e) {
      throw Exception('Error al actualizar ubicación: ${e.toString()}');
    }
  }

  // Obtener ubicación de un repartidor
  Future<Ubicacion?> getRepartidorLocation(String repartidorId) async {
    try {
      final doc = await _firestore
          .collection('ubicaciones_repartidores')
          .doc(repartidorId)
          .get();

      if (doc.exists) {
        return Ubicacion.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener ubicación: ${e.toString()}');
    }
  }

  // Escuchar ubicación de un repartidor en tiempo real
  Stream<Ubicacion?> watchRepartidorLocation(String repartidorId) {
    return _firestore
        .collection('ubicaciones_repartidores')
        .doc(repartidorId)
        .snapshots()
        .map((snapshot) {
          if (snapshot.exists) {
            return Ubicacion.fromJson(snapshot.data()!);
          }
          return null;
        });
  }

  // Calcular distancia entre dos puntos (en metros)
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }
}
