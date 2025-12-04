import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario_model.dart';
import '../utils/constants.dart';

// Servicio de gestión de usuarios - JonthanAyala
// Solo accesible para administradores
class UsuarioService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtener todos los usuarios (solo admin)
  Future<List<Usuario>> obtenerTodosUsuarios() async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.usuariosCollection)
          .orderBy('nombre')
          .get();

      return snapshot.docs.map((doc) => Usuario.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception('Error al obtener usuarios: $e');
    }
  }

  // Obtener usuarios por rol
  Future<List<Usuario>> obtenerUsuariosPorRol(String rol) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.usuariosCollection)
          .where('rol', isEqualTo: rol)
          .orderBy('nombre')
          .get();

      return snapshot.docs.map((doc) => Usuario.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception('Error al obtener usuarios por rol: $e');
    }
  }

  // Obtener un usuario por ID
  Future<Usuario?> obtenerUsuarioPorId(String id) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.usuariosCollection)
          .doc(id)
          .get();

      if (doc.exists) {
        return Usuario.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener usuario: $e');
    }
  }

  // Actualizar usuario (solo admin)
  Future<bool> actualizarUsuario(Usuario usuario) async {
    try {
      await _firestore
          .collection(AppConstants.usuariosCollection)
          .doc(usuario.id)
          .update(usuario.toJson());
      return true;
    } catch (e) {
      throw Exception('Error al actualizar usuario: $e');
    }
  }

  // Eliminar usuario (solo admin, no puede eliminar ADMIN_MASTER)
  Future<bool> eliminarUsuario(String id) async {
    try {
      // Proteger al admin master
      if (id == 'ADMIN_MASTER') {
        throw Exception('No se puede eliminar al administrador principal');
      }

      await _firestore
          .collection(AppConstants.usuariosCollection)
          .doc(id)
          .delete();
      return true;
    } catch (e) {
      throw Exception('Error al eliminar usuario: $e');
    }
  }

  // Cambiar rol de usuario (solo admin)
  Future<bool> cambiarRol(String userId, String nuevoRol) async {
    try {
      // Proteger al admin master
      if (userId == 'ADMIN_MASTER') {
        throw Exception(
          'No se puede cambiar el rol del administrador principal',
        );
      }

      await _firestore
          .collection(AppConstants.usuariosCollection)
          .doc(userId)
          .update({'rol': nuevoRol});
      return true;
    } catch (e) {
      throw Exception('Error al cambiar rol: $e');
    }
  }

  // Buscar usuarios por nombre o email
  Future<List<Usuario>> buscarUsuarios(String query) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.usuariosCollection)
          .get();

      final usuarios = snapshot.docs
          .map((doc) => Usuario.fromJson(doc.data()))
          .toList();

      // Filtrar localmente por nombre o email
      return usuarios.where((usuario) {
        final nombreLower = usuario.nombre.toLowerCase();
        final emailLower = usuario.email.toLowerCase();
        final queryLower = query.toLowerCase();
        return nombreLower.contains(queryLower) ||
            emailLower.contains(queryLower);
      }).toList();
    } catch (e) {
      throw Exception('Error al buscar usuarios: $e');
    }
  }
}
