package mx.edu.utez.paqueteria.exception;

public class NotificacionException extends RuntimeException {
    public NotificacionException(String mensaje, Throwable causa) {
        super(mensaje, causa);
    }
}
