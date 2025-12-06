# 📱 API de Notificaciones - Backend Spring Boot

## 🚀 Inicio Rápido

### 1. Configurar Firebase

Ver [FIREBASE_SETUP.md](FIREBASE_SETUP.md) para instrucciones detalladas.

### 2. Compilar y Ejecutar

```bash
# Compilar
mvn clean install

# Ejecutar
mvn spring-boot:run
```

El servidor iniciará en `http://localhost:8080`

---

## 📡 Endpoints de API

### Health Check

```http
GET /api/notificaciones/health
```

**Respuesta:**

```json
{
  "status": "OK",
  "service": "Notificaciones FCM",
  "timestamp": 1733371200000
}
```

---

### 1. Paquete Tomado por Repartidor

**Endpoint:** `POST /api/notificaciones/paquete-tomado`

**Descripción:** Notifica al cliente que su paquete fue tomado por un repartidor.

**Request Body:**

```json
{
  "paqueteId": "PKG-001",
  "clienteId": "user123",
  "repartidorId": "rep456",
  "repartidorNombre": "Juan Pérez"
}
```

**Respuesta Exitosa:**

```json
{
  "success": true,
  "mensaje": "Notificación de paquete tomado enviada",
  "paqueteId": "PKG-001",
  "timestamp": 1733371200000
}
```

**Notificación FCM Enviada:**

```json
{
  "notification": {
    "title": "🚚 Paquete en camino",
    "body": "Juan Pérez tomó tu paquete y está en camino"
  },
  "data": {
    "tipo": "asignacion",
    "paqueteId": "PKG-001",
    "repartidorId": "rep456",
    "userId": "user123"
  }
}
```

**Ejemplo cURL:**

```bash
curl -X POST http://localhost:8080/api/notificaciones/paquete-tomado \
  -H "Content-Type: application/json" \
  -d '{
    "paqueteId": "PKG-001",
    "clienteId": "user123",
    "repartidorId": "rep456",
    "repartidorNombre": "Juan Pérez"
  }'
```

---

### 2. Nuevo Paquete Disponible

**Endpoint:** `POST /api/notificaciones/nuevo-paquete`

**Descripción:** Notifica a TODOS los repartidores sobre un nuevo paquete disponible.

**Request Body:**

```json
{
  "paqueteId": "PKG-002",
  "destinatario": "María López",
  "direccion": "Calle 123, Col. Centro"
}
```

**Respuesta Exitosa:**

```json
{
  "success": true,
  "mensaje": "Notificaciones de nuevo paquete enviadas a repartidores",
  "paqueteId": "PKG-002",
  "timestamp": 1733371200000
}
```

**Notificación FCM Enviada (a cada repartidor):**

```json
{
  "notification": {
    "title": "📦 Nuevo paquete disponible",
    "body": "Paquete para María López - Calle 123, Col. Centro"
  },
  "data": {
    "tipo": "paquete",
    "paqueteId": "PKG-002",
    "destinatario": "María López",
    "direccion": "Calle 123, Col. Centro",
    "userId": "rep456" // ID del repartidor receptor
  }
}
```

**Ejemplo cURL:**

```bash
curl -X POST http://localhost:8080/api/notificaciones/nuevo-paquete \
  -H "Content-Type: application/json" \
  -d '{
    "paqueteId": "PKG-002",
    "destinatario": "María López",
    "direccion": "Calle 123, Col. Centro"
  }'
```

---

### 3. Paquete Entregado

**Endpoint:** `POST /api/notificaciones/paquete-entregado`

**Descripción:** Notifica al cliente que su paquete fue entregado.

**Request Body:**

```json
{
  "paqueteId": "PKG-001",
  "clienteId": "user123"
}
```

**Respuesta Exitosa:**

```json
{
  "success": true,
  "mensaje": "Notificación de paquete entregado enviada",
  "paqueteId": "PKG-001",
  "timestamp": 1733371200000
}
```

**Notificación FCM Enviada:**

```json
{
  "notification": {
    "title": "✅ Paquete entregado",
    "body": "Tu paquete ha sido entregado exitosamente"
  },
  "data": {
    "tipo": "entrega",
    "paqueteId": "PKG-001",
    "userId": "user123"
  }
}
```

**Ejemplo cURL:**

```bash
curl -X POST http://localhost:8080/api/notificaciones/paquete-entregado \
  -H "Content-Type: application/json" \
  -d '{
    "paqueteId": "PKG-001",
    "clienteId": "user123"
  }'
```

---

## 🔄 Integración con Cloud Functions

### Opción 1: Firestore Triggers (Recomendado)

Crea Cloud Functions que detecten cambios en Firestore y llamen al backend:

```javascript
// functions/index.js
const functions = require("firebase-functions");
const axios = require("axios");

const BACKEND_URL = "http://tu-servidor:8080/api/notificaciones";

// Trigger cuando se crea un paquete
exports.onPaqueteCreado = functions.firestore
  .document("paquetes/{paqueteId}")
  .onCreate(async (snap, context) => {
    const paquete = snap.data();

    await axios.post(`${BACKEND_URL}/nuevo-paquete`, {
      paqueteId: context.params.paqueteId,
      destinatario: paquete.destinatario,
      direccion: paquete.direccion,
    });
  });

// Trigger cuando se actualiza un paquete
exports.onPaqueteActualizado = functions.firestore
  .document("paquetes/{paqueteId}")
  .onUpdate(async (change, context) => {
    const antes = change.before.data();
    const despues = change.after.data();

    // Paquete tomado
    if (!antes.repartidorId && despues.repartidorId) {
      // Obtener nombre del repartidor
      const repartidorDoc = await admin
        .firestore()
        .collection("usuarios")
        .doc(despues.repartidorId)
        .get();

      await axios.post(`${BACKEND_URL}/paquete-tomado`, {
        paqueteId: context.params.paqueteId,
        clienteId: despues.clienteId,
        repartidorId: despues.repartidorId,
        repartidorNombre: repartidorDoc.data().nombre,
      });
    }

    // Paquete entregado
    if (antes.estado !== "entregado" && despues.estado === "entregado") {
      await axios.post(`${BACKEND_URL}/paquete-entregado`, {
        paqueteId: context.params.paqueteId,
        clienteId: despues.clienteId,
      });
    }
  });
```

### Opción 2: Llamadas Directas desde Flutter

También puedes llamar directamente desde la app Flutter cuando sea necesario:

```dart
// En paquete_service.dart
Future<void> tomarPaquete(String paqueteId, String repartidorId) async {
  // 1. Actualizar Firestore
  await _firestore.collection('paquetes').doc(paqueteId).update({
    'repartidorId': repartidorId,
    'estado': 'en_transito',
  });

  // 2. Llamar backend para notificación
  final response = await http.post(
    Uri.parse('http://tu-servidor:8080/api/notificaciones/paquete-tomado'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'paqueteId': paqueteId,
      'clienteId': clienteId,
      'repartidorId': repartidorId,
      'repartidorNombre': repartidorNombre,
    }),
  );
}
```

---

## 📊 Tipos de Notificación

| Tipo       | Valor          | Icono Frontend | Uso                           |
| ---------- | -------------- | -------------- | ----------------------------- |
| Asignación | `"asignacion"` | 🚚             | Paquete tomado por repartidor |
| Paquete    | `"paquete"`    | 📦             | Nuevo paquete disponible      |
| Entrega    | `"entrega"`    | ✅             | Paquete entregado             |

---

## 🔍 Logs y Debugging

### Ver logs del servidor

```bash
# Logs en consola
mvn spring-boot:run

# Logs con nivel DEBUG
mvn spring-boot:run -Dlogging.level.mx.edu.utez.paqueteria=DEBUG
```

### Logs importantes

- ✅ `Firebase Admin SDK inicializado correctamente`
- ✅ `Notificación enviada exitosamente: projects/...`
- ⚠️ `Cliente {id} no tiene token FCM registrado`
- ⚠️ `No hay repartidores con tokens FCM registrados`
- ❌ `Error al enviar notificación a token: ...`

---

## ⚠️ Troubleshooting

### Error: "Firebase Admin SDK no inicializado"

- Verifica que `firebase-service-account.json` esté en `src/main/resources/`
- Verifica que el archivo tenga el formato JSON correcto

### Error: "No se encontró usuario en Firestore"

- Verifica que el `userId` sea correcto
- Verifica que el usuario exista en Firestore collection `usuarios`

### Error: "Token FCM inválido"

- El token puede haber expirado
- El usuario puede haber desinstalado la app
- Verifica que el token en Firestore esté actualizado

### No se reciben notificaciones

1. Verifica que el usuario tenga `fcmToken` en Firestore
2. Verifica que el backend esté ejecutándose
3. Verifica los logs del backend
4. Verifica que la app Flutter esté en foreground o background

---

## 📦 Estructura del Proyecto

```
paqueteria/
├── src/main/java/mx/edu/utez/paqueteria/
│   ├── config/
│   │   └── FirebaseConfig.java
│   ├── controller/
│   │   └── NotificacionController.java
│   ├── dto/
│   │   ├── NotificacionDTO.java
│   │   └── PaqueteEventDTO.java
│   ├── service/
│   │   ├── FirebaseMessagingService.java
│   │   └── NotificacionService.java
│   └── PaqueteriaApplication.java
├── src/main/resources/
│   ├── application.properties
│   └── firebase-service-account.json  ← IMPORTANTE
├── pom.xml
├── FIREBASE_SETUP.md
└── README.md
```

---

## 🎯 Próximos Pasos

1. ✅ Descargar `firebase-service-account.json`
2. ✅ Colocarlo en `src/main/resources/`
3. ✅ Ejecutar `mvn clean install`
4. ✅ Ejecutar `mvn spring-boot:run`
5. ✅ Probar con cURL o Postman
6. ✅ Integrar con Cloud Functions o Flutter

---

**Desarrollado por:** JonthanAyala  
**Fecha:** 2025-12-05  
**Proyecto:** Tucanes DMI 10A
