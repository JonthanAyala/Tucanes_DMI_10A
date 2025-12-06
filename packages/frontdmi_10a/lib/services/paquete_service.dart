import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart'; // COMENTADO: Para usar en el futuro con Firebase Storage
import '../models/paquete_model.dart';
import 'local_storage_service.dart'; // Servicio de almacenamiento local
import 'notificacion_backend_service.dart'; // JonthanAyala - Backend de notificaciones

// Servicio de gestión de paquetes - BojitaNoir
// NOTA: Actualmente usa almacenamiento LOCAL para fotos
// Para migrar a Firebase Storage, descomentar imports y cambiar método _guardarFoto()
class PaqueteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseStorage _storage = FirebaseStorage.instance; // COMENTADO: Para Firebase Storage
  final LocalStorageService _localStorage =
      LocalStorageService(); // Almacenamiento local
  final NotificacionBackendService _backendService =
      NotificacionBackendService(); // JonthanAyala - Backend

  // Obtener todos los paquetes
  Stream<List<Paquete>> obtenerPaquetes() {
    return _firestore
        .collection('paquetes')
        .orderBy('fechaCreacion', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Paquete.fromJson({'id': doc.id, ...doc.data()});
          }).toList();
        });
  }

  // Obtener paquetes por cliente
  // NOTA: Ordenamiento en memoria para evitar índices compuestos en Firestore
  Stream<List<Paquete>> obtenerPaquetesPorCliente(String clienteId) {
    return _firestore
        .collection('paquetes')
        .where('clienteId', isEqualTo: clienteId)
        .snapshots()
        .map((snapshot) {
          final paquetes = snapshot.docs.map((doc) {
            return Paquete.fromJson({'id': doc.id, ...doc.data()});
          }).toList();

          // Ordenar por fecha de creación en memoria
          paquetes.sort((a, b) => b.fechaCreacion.compareTo(a.fechaCreacion));
          return paquetes;
        });
  }

  // Obtener paquetes por repartidor
  // NOTA: Ordenamiento en memoria para evitar índices compuestos en Firestore
  Stream<List<Paquete>> obtenerPaquetesPorRepartidor(String repartidorId) {
    return _firestore
        .collection('paquetes')
        .where('repartidorId', isEqualTo: repartidorId)
        .snapshots()
        .map((snapshot) {
          final paquetes = snapshot.docs.map((doc) {
            return Paquete.fromJson({'id': doc.id, ...doc.data()});
          }).toList();

          // Ordenar por fecha de creación en memoria
          paquetes.sort((a, b) => b.fechaCreacion.compareTo(a.fechaCreacion));
          return paquetes;
        });
  }

  // Obtener paquete por ID
  Future<Paquete?> obtenerPaquetePorId(String id) async {
    try {
      final doc = await _firestore.collection('paquetes').doc(id).get();
      if (doc.exists) {
        return Paquete.fromJson({'id': doc.id, ...doc.data()!});
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener paquete: ${e.toString()}');
    }
  }

  // Crear paquete con foto (usa almacenamiento LOCAL)
  Future<void> crearPaquete(Paquete paquete, File? foto) async {
    try {
      String? fotoRuta;

      if (foto != null) {
        // ALMACENAMIENTO LOCAL (actual)
        fotoRuta = await _guardarFotoLocal(foto, paquete.id);

        // FIREBASE STORAGE (comentado para futuro uso)
        // fotoRuta = await _guardarFotoFirebase(foto, paquete.id);
      }

      // Generar código QR único - JonthanAyala
      final codigoQR =
          'PKG-${paquete.id}-${DateTime.now().millisecondsSinceEpoch}';

      final paqueteConFoto = paquete.copyWith(
        fotoUrl: fotoRuta,
        codigoQR: codigoQR,
      );

      // 1. Guardar en Firestore
      await _firestore
          .collection('paquetes')
          .doc(paquete.id)
          .set(paqueteConFoto.toJson());

      // 2. Notificar a repartidores (backend)
      // No esperar respuesta para no bloquear
      _backendService
          .notificarNuevoPaquete(
            paqueteId: paquete.id,
            // destinatario y direccion ya no son necesarios, el backend los busca
          )
          .catchError((e) {
            print('Error al notificar nuevo paquete al backend: $e');
            return false;
          });
    } catch (e) {
      throw Exception('Error al crear paquete: ${e.toString()}');
    }
  }

  // Actualizar paquete (usa almacenamiento LOCAL)
  Future<void> actualizarPaquete(Paquete paquete, File? nuevaFoto) async {
    try {
      String? fotoRuta = paquete.fotoUrl;

      if (nuevaFoto != null) {
        // ALMACENAMIENTO LOCAL (actual)
        fotoRuta = await _guardarFotoLocal(nuevaFoto, paquete.id);

        // FIREBASE STORAGE (comentado para futuro uso)
        // fotoRuta = await _guardarFotoFirebase(nuevaFoto, paquete.id);
      }

      final paqueteActualizado = paquete.copyWith(fotoUrl: fotoRuta);

      await _firestore
          .collection('paquetes')
          .doc(paquete.id)
          .update(paqueteActualizado.toJson());
    } catch (e) {
      throw Exception('Error al actualizar paquete: ${e.toString()}');
    }
  }

  // Eliminar paquete (solo admin)
  Future<void> eliminarPaquete(String id) async {
    try {
      // Obtener paquete para eliminar foto si existe
      final paquete = await obtenerPaquetePorId(id);

      if (paquete?.fotoUrl != null) {
        // ALMACENAMIENTO LOCAL (actual)
        await _localStorage.eliminarFoto(paquete!.fotoUrl!);

        // FIREBASE STORAGE (comentado para futuro uso)
        // await _eliminarFotoFirebase(paquete!.fotoUrl!);
      }

      await _firestore.collection('paquetes').doc(id).delete();
    } catch (e) {
      throw Exception('Error al eliminar paquete: ${e.toString()}');
    }
  }

  // Actualizar estado del paquete
  Future<void> actualizarEstado(String id, String nuevoEstado) async {
    try {
      // 1. Actualizar Firestore
      await _firestore.collection('paquetes').doc(id).update({
        'estado': nuevoEstado,
      });

      // 2. Si el estado es "entregado", notificar al cliente
      if (nuevoEstado == 'entregado') {
        final paqueteDoc = await _firestore
            .collection('paquetes')
            .doc(id)
            .get();

        if (paqueteDoc.exists) {
          final paqueteData = paqueteDoc.data()!;

          // Notificar al backend (no esperar respuesta)
          _backendService
              .notificarPaqueteEntregado(
                paqueteId: id,
                clienteId: paqueteData['clienteId'],
              )
              .catchError((e) {
                print('Error al notificar paquete entregado al backend: $e');
                return false;
              });
        }
      }
    } catch (e) {
      throw Exception('Error al actualizar estado: ${e.toString()}');
    }
  }

  // ============================================
  // MÉTODOS PARA PAQUETES CERCANOS - JonthanAyala
  // ============================================

  // Obtener paquetes disponibles (sin repartidor asignado)
  Future<List<Paquete>> obtenerPaquetesDisponibles() async {
    try {
      final snapshot = await _firestore
          .collection('paquetes')
          .where('repartidorId', isNull: true)
          .where('estado', isEqualTo: 'pendiente')
          .get();

      return snapshot.docs
          .map((doc) => Paquete.fromJson({'id': doc.id, ...doc.data()}))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener paquetes disponibles: ${e.toString()}');
    }
  }

  // Tomar paquete (auto-asignarse)
  Future<bool> tomarPaquete(String paqueteId, String repartidorId) async {
    try {
      // 1. Obtener datos del paquete y repartidor para la notificación
      final paqueteDoc = await _firestore
          .collection('paquetes')
          .doc(paqueteId)
          .get();
      // Ya no necesitamos buscar al repartidor explícitamente para el nombre
      // El backend lo hará

      if (!paqueteDoc.exists) {
        return false;
      }

      final paqueteData = paqueteDoc.data()!;

      // 2. Actualizar Firestore
      await _firestore.collection('paquetes').doc(paqueteId).update({
        'repartidorId': repartidorId,
        'estado': 'en_transito',
      });

      // 3. Notificar al cliente (backend)
      // No esperar respuesta para no bloquear
      _backendService
          .notificarPaqueteTomado(
            paqueteId: paqueteId,
            clienteId: paqueteData['clienteId'],
            repartidorId: repartidorId,
            // repartidorNombre ya no es necesario, el backend lo busca
          )
          .catchError((e) {
            print('Error al notificar paquete tomado al backend: $e');
            return false;
          });

      return true;
    } catch (e) {
      print('Error en tomarPaquete: $e');
      return false;
    }
  }

  // ============================================
  // MÉTODOS DE ALMACENAMIENTO LOCAL (ACTUAL)
  // ============================================

  // Guardar foto localmente en el dispositivo
  Future<String> _guardarFotoLocal(File foto, String paqueteId) async {
    try {
      return await _localStorage.guardarFoto(foto, paqueteId);
    } catch (e) {
      throw Exception('Error al guardar foto localmente: ${e.toString()}');
    }
  }

  // ============================================
  // MÉTODOS DE FIREBASE STORAGE (COMENTADOS)
  // Para usar en el futuro cuando tengas plan de pago
  // ============================================

  /* 
  // Guardar foto en Firebase Storage
  Future<String> _guardarFotoFirebase(File foto, String paqueteId) async {
    try {
      final ref = _storage.ref().child('paquetes/$paqueteId.jpg');
      await ref.putFile(foto);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Error al subir foto a Firebase: ${e.toString()}');
    }
  }
  
  // Eliminar foto de Firebase Storage
  Future<void> _eliminarFotoFirebase(String fotoUrl) async {
    try {
      final ref = _storage.refFromURL(fotoUrl);
      await ref.delete();
    } catch (e) {
      // No lanzar error si la foto no existe
      print('Error al eliminar foto de Firebase: ${e.toString()}');
    }
  }
  */
}
