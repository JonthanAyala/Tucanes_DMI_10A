package mx.edu.utez.paqueteria.service;

import com.google.firebase.messaging.*;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * Servicio para envío de notificaciones FCM
 *
 * @author JonthanAyala
 */
@Service
public class FirebaseMessagingService {

    /**
     * Enviar notificación a un solo dispositivo
     */
    public void enviarNotificacion(String fcmToken, String titulo, String cuerpo, Map<String, String> data) {
        try {
            Message message = Message.builder()
                    .setToken(fcmToken)
                    .setNotification(Notification.builder()
                            .setTitle(titulo)
                            .setBody(cuerpo)
                            .build())
                    .putAllData(data)
                    .setAndroidConfig(AndroidConfig.builder()
                            .setPriority(AndroidConfig.Priority.HIGH)
                            .setNotification(AndroidNotification.builder()
                                    .setChannelId("paqueteria_channel")
                                    .setPriority(AndroidNotification.Priority.HIGH)
                                    .build())
                            .build())
                    .build();

            String response = FirebaseMessaging.getInstance().send(message);
            System.out.println("Notificación enviada exitosamente: " + response);
        } catch (FirebaseMessagingException e) {
            if (e.getMessagingErrorCode() == MessagingErrorCode.UNREGISTERED) {
                System.out.println("El token FCM " + fcmToken + " no es válido o el usuario ya no está registrado.");
            } else {
                System.out.println("Error al enviar notificación a token: " + fcmToken);
                e.printStackTrace();
            }
        } catch (Exception e) {
            System.err.println("Error inesperado al enviar la notificación: " + e.getMessage());
        }
    }

    /**
     * Enviar notificación a múltiples dispositivos
     */
    public void enviarNotificacionMultiple(List<String> tokens, String titulo, String cuerpo,
            Map<String, String> data) {
        if (tokens == null || tokens.isEmpty()) {
            System.out.println("No hay tokens para enviar notificaciones");
            return;
        }

        try {
            MulticastMessage message = MulticastMessage.builder()
                    .addAllTokens(tokens)
                    .setNotification(Notification.builder()
                            .setTitle(titulo)
                            .setBody(cuerpo)
                            .build())
                    .putAllData(data)
                    .setAndroidConfig(AndroidConfig.builder()
                            .setPriority(AndroidConfig.Priority.HIGH)
                            .setNotification(AndroidNotification.builder()
                                    .setChannelId("paqueteria_channel")
                                    .setPriority(AndroidNotification.Priority.HIGH)
                                    .build())
                            .build())
                    .build();

            BatchResponse response = FirebaseMessaging.getInstance().sendMulticast(message);
            System.out.println("Notificaciones enviadas: " + response.getSuccessCount() + " exitosas, "
                    + response.getFailureCount() + " fallidas de " + tokens.size() + " total");

            // Log de tokens fallidos
            if (response.getFailureCount() > 0) {
                List<SendResponse> responses = response.getResponses();
                for (int i = 0; i < responses.size(); i++) {
                    if (!responses.get(i).isSuccessful()) {
                        FirebaseMessagingException exception = (FirebaseMessagingException) responses.get(i)
                                .getException();
                        if (exception != null && exception.getMessagingErrorCode() == MessagingErrorCode.UNREGISTERED) {
                            System.out.println("El token [" + tokens.get(i)
                                    + "] no es válido o el usuario ya no está registrado.");
                        } else {
                            System.err.println("Error enviando a token [" + tokens.get(i) + "]: "
                                    + (exception != null ? exception.getMessage() : "Desconocido"));
                        }
                    }
                }
            }
        } catch (FirebaseMessagingException e) {
            System.err.println("Error al enviar notificaciones múltiples: " + e.getMessage());
            e.printStackTrace();
        }
    }
}