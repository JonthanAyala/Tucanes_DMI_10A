import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Servicio de notificaciones push - JaimeCAST69
class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Inicializar servicio de notificaciones
  Future<void> inicializar() async {
    try {
      // Solicitar permisos
      await _messaging.requestPermission(alert: true, badge: true, sound: true);

      // Configurar notificaciones locales
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const initSettings = InitializationSettings(android: androidSettings);

      await _localNotifications.initialize(initSettings);

      // Obtener token FCM
      final token = await _messaging.getToken();
      print('FCM Token: $token');

      // Escuchar mensajes en foreground
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Escuchar mensajes cuando la app se abre desde notificación
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
    } catch (e) {
      print('Error al inicializar notificaciones: ${e.toString()}');
    }
  }

  // Manejar mensaje en foreground
  void _handleForegroundMessage(RemoteMessage message) {
    print('Mensaje recibido en foreground: ${message.notification?.title}');

    if (message.notification != null) {
      _mostrarNotificacionLocal(
        message.notification!.title ?? '',
        message.notification!.body ?? '',
      );
    }
  }

  // Manejar cuando se abre la app desde notificación
  void _handleMessageOpenedApp(RemoteMessage message) {
    print('App abierta desde notificación: ${message.notification?.title}');
  }

  // Mostrar notificación local
  Future<void> _mostrarNotificacionLocal(String titulo, String cuerpo) async {
    const androidDetails = AndroidNotificationDetails(
      'paqueteria_channel',
      'Paquetería',
      channelDescription: 'Notificaciones de paquetes',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      DateTime.now().millisecond,
      titulo,
      cuerpo,
      notificationDetails,
    );
  }

  // Obtener token FCM
  Future<String?> obtenerToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      print('Error al obtener token: ${e.toString()}');
      return null;
    }
  }
}
