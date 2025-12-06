# 🔥 IMPORTANTE: Configuración de Firebase

## Paso 1: Descargar Service Account Key

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Selecciona tu proyecto
3. Ve a **Project Settings** (⚙️ Configuración del proyecto)
4. Pestaña **Service Accounts**
5. Click en **Generate new private key**
6. Descarga el archivo JSON

## Paso 2: Colocar el archivo

1. Renombra el archivo descargado a: `firebase-service-account.json`
2. Colócalo en: `src/main/resources/firebase-service-account.json`

## Paso 3: Verificar

El archivo debe tener esta estructura:

```json
{
  "type": "service_account",
  "project_id": "tu-proyecto-id",
  "private_key_id": "...",
  "private_key": "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-xxxxx@tu-proyecto-id.iam.gserviceaccount.com",
  "client_id": "...",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "..."
}
```

## ⚠️ Seguridad

**NUNCA** subas este archivo a Git. Ya está en `.gitignore`.

---

**Autor:** JonthanAyala  
**Proyecto:** Tucanes DMI 10A
