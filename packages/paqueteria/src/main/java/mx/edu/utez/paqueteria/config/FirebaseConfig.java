package mx.edu.utez.paqueteria.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource; // <--- IMPORTANTE: Nuevo import

import javax.annotation.PostConstruct;
import java.io.InputStream;

/**
 * Configuración de Firebase Admin SDK
 * 
 * @author JonthanAyala
 */
@Configuration
public class FirebaseConfig {

    @PostConstruct
    public void initialize() {
        try {
            InputStream serviceAccount = new ClassPathResource("firebase-service-account.json").getInputStream();

            FirebaseOptions options = FirebaseOptions.builder()
                    .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                    .build();

            if (FirebaseApp.getApps().isEmpty()) {
                FirebaseApp.initializeApp(options);
                System.out.println("Firebase Admin SDK inicializado correctamente");
            }
        } catch (Exception e) {
            System.out.println("Error al inicializar Firebase Admin SDK: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
