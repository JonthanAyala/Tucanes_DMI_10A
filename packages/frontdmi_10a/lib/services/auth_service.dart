import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario_model.dart';

// Servicio de autenticación con Firebase - JaimeCAST69
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtener usuario actual
  User? get currentUser => _auth.currentUser;

  // Stream de cambios de autenticación
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Login con email y contraseña
  Future<Usuario?> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final doc = await _firestore
            .collection('usuarios')
            .doc(userCredential.user!.uid)
            .get();

        if (doc.exists) {
          return Usuario.fromJson({'id': doc.id, ...doc.data()!});
        }
      }
      return null;
    } catch (e) {
      throw Exception('Error al iniciar sesión: ${e.toString()}');
    }
  }

  // Registro de nuevo usuario
  Future<Usuario?> registro({
    required String nombre,
    required String email,
    required String password,
    required String rol,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final usuario = Usuario(
          id: userCredential.user!.uid,
          nombre: nombre,
          email: email,
          rol: rol,
        );

        await _firestore
            .collection('usuarios')
            .doc(usuario.id)
            .set(usuario.toJson());

        return usuario;
      }
      return null;
    } catch (e) {
      throw Exception('Error al registrar usuario: ${e.toString()}');
    }
  }

  // Cerrar sesión
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Error al cerrar sesión: ${e.toString()}');
    }
  }

  // Obtener datos del usuario actual
  Future<Usuario?> obtenerUsuarioActual() async {
    try {
      final user = currentUser;
      if (user != null) {
        final doc = await _firestore.collection('usuarios').doc(user.uid).get();
        if (doc.exists) {
          return Usuario.fromJson({'id': doc.id, ...doc.data()!});
        }
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener usuario: ${e.toString()}');
    }
  }

  // Verificar si hay sesión activa
  bool isLoggedIn() {
    return currentUser != null;
  }
}
