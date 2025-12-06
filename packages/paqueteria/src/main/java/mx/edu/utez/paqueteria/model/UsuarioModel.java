package mx.edu.utez.paqueteria.model;

import com.google.cloud.Timestamp;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UsuarioModel {
    private String id;
    private String nombre;
    private String email;
    private String rol;
    private String fcmToken;
    private String token;
    private Timestamp ultimaActualizacionToken;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRol() {
        return rol;
    }

    public void setRol(String rol) {
        this.rol = rol;
    }

    public String getFcmToken() {
        return fcmToken;
    }

    public void setFcmToken(String fcmToken) {
        this.fcmToken = fcmToken;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public Timestamp getUltimaActualizacionToken() {
        return ultimaActualizacionToken;
    }

    public void setUltimaActualizacionToken(Timestamp ultimaActualizacionToken) {
        this.ultimaActualizacionToken = ultimaActualizacionToken;
    }
}
