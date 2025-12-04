# 👥 Asignación de Tareas por Integrante del Equipo

## 📋 Resumen de Tareas por Integrante

### 🟦 BojitaNoir

1. ✅ Ver lista de paquetes (#1)
2. ✅ Ver detalle de paquete (#11)
3. ✅ Geolocalización y mapa (#16)

### 🟨 Aserejex22

1. ✅ Navegación y diseño UI profesional (#5)
2. ✅ Crear paquete con foto (#10)
3. ✅ Cámara y escaneo QR (#13)

### 🟩 JaimeCAST69

1. ✅ Pantalla de Login con validaciones (#6)
2. ✅ Notificaciones push (#15)
3. ✅ Persistencia local y sincronización (#17)
4. ✅ Pantalla de Registro con selección de rol (#7)

### 🟧 JonthanAyala

1. ✅ Persistencia de sesión y logout (#8)
2. ✅ Editar paquete (solo admin/repartidor) (#12)
3. ✅ Eliminar paquete (solo admin) (#14)
4. ✅ Documentación viva (#18)
5. ✅ **NUEVO:** Gestión de usuarios (admin)

---

## 📁 Asignación Detallada por Archivo

### 🔧 Configuración Base

#### `pubspec.yaml`

**Responsable:** JaimeCAST69 (Configuración inicial)

- Líneas 1-61: Configuración completa de dependencias

---

### 📦 Modelos (Models)

#### `lib/models/usuario_model.dart`

**Responsable:** JaimeCAST69

- Líneas 1-66: Modelo completo de Usuario

#### `lib/models/paquete_model.dart`

**Responsable:** BojitaNoir

- Líneas 1-82: Modelo completo de Paquete

#### `lib/models/ubicacion_model.dart`

**Responsable:** BojitaNoir

- Líneas 1-30: Modelo de Ubicación para geolocalización

---

### 🔌 Servicios (Services)

#### `lib/services/auth_service.dart`

**Responsable:** JaimeCAST69

- Líneas 1-107: Servicio completo de autenticación

#### `lib/services/storage_service.dart`

**Responsable:** JonthanAyala

- Líneas 1-67: Servicio de persistencia local (SharedPreferences)

#### `lib/services/paquete_service.dart`

**Responsable:** BojitaNoir

- Líneas 1-143: Servicio CRUD de paquetes con Firestore

#### `lib/services/notification_service.dart`

**Responsable:** JaimeCAST69

- Líneas 1-94: Servicio de notificaciones push (FCM)

#### `lib/services/database_service.dart`

**Responsable:** JaimeCAST69

- Líneas 1-120: Servicio de SQLite para persistencia local

#### `lib/services/location_service.dart`

**Responsable:** BojitaNoir

- Líneas 1-95: Servicio de geolocalización

#### `lib/services/local_storage_service.dart`

**Responsable:** Aserejex22

- Líneas 1-45: Servicio de almacenamiento local de fotos

#### `lib/services/usuario_service.dart`

**Responsable:** JonthanAyala

- Líneas 1-135: Servicio de gestión de usuarios (NUEVO)

---

### 🎨 ViewModels

#### `lib/viewmodels/auth_viewmodel.dart`

**Responsable:** JaimeCAST69

- Líneas 1-127: ViewModel de autenticación

#### `lib/viewmodels/paquete_viewmodel.dart`

**Responsable:** BojitaNoir

- Líneas 1-155: ViewModel de paquetes

#### `lib/viewmodels/usuario_viewmodel.dart`

**Responsable:** JonthanAyala

- Líneas 1-170: ViewModel de usuarios (NUEVO)

---

### 🖼️ Vistas (Views)

#### `lib/views/login_view.dart`

**Responsable:** JaimeCAST69

- Líneas 1-179: Vista completa de login

#### `lib/views/registro_view.dart`

**Responsable:** JaimeCAST69 (inicial) + Modificaciones posteriores

- Líneas 1-234: Vista de registro (modificada para solo repartidores)

#### `lib/views/home_view.dart`

**Responsables:** Aserejex22 (inicial) + JonthanAyala (gestión usuarios)

- Líneas 1-11: Imports y comentarios - **Aserejex22**
- Líneas 12-75: Navegación con pestaña usuarios - **JonthanAyala** (modificación)

#### `lib/views/lista_paquetes_view.dart`

**Responsable:** BojitaNoir

- Líneas 1-204: Vista completa de lista de paquetes

#### `lib/views/detalle_paquete_view.dart`

**Responsables:** BojitaNoir (inicial) + Aserejex22 (QR) + JonthanAyala (eliminar)

- Líneas 1-80: Estructura base y AppBar - **BojitaNoir**
- Líneas 81-200: Detalle del paquete - **BojitaNoir**
- Líneas 60-75: Botón de escaneo QR - **Aserejex22**
- Líneas 289-330: Método de eliminación con protección - **JonthanAyala**

#### `lib/views/crear_paquete_view.dart`

**Responsable:** Aserejex22

- Líneas 1-250: Vista completa de creación con cámara/galería

#### `lib/views/editar_paquete_view.dart`

**Responsable:** JonthanAyala

- Líneas 1-280: Vista completa de edición de paquetes

#### `lib/views/perfil_view.dart`

**Responsable:** JonthanAyala

- Líneas 1-150: Vista de perfil con logout

#### `lib/views/qr_scanner_view.dart`

**Responsable:** Aserejex22

- Líneas 1-200: Vista completa de escáner QR

#### `lib/views/mapa_view.dart`

**Responsable:** BojitaNoir

- Líneas 1-350: Vista de mapa con geolocalización (sin Google Maps SDK)

#### `lib/views/gestion_usuarios_view.dart`

**Responsable:** JonthanAyala

- Líneas 1-320: Vista completa de gestión de usuarios (NUEVO)

#### `lib/views/crear_usuario_view.dart`

**Responsable:** JonthanAyala

- Líneas 1-280: Vista de creación de usuarios por admin (NUEVO)

#### `lib/views/editar_usuario_view.dart`

**Responsable:** JonthanAyala

- Líneas 1-300: Vista de edición de usuarios (NUEVO)

---

### 🧩 Widgets Reutilizables

#### `lib/widgets/custom_button.dart`

**Responsable:** Aserejex22

- Líneas 1-64: Widget de botón personalizado

#### `lib/widgets/custom_text_field.dart`

**Responsables:** Aserejex22 (inicial) + JonthanAyala (enabled)

- Líneas 1-14: Estructura inicial - **Aserejex22**
- Línea 15: Parámetro enabled - **JonthanAyala**
- Líneas 16-90: Implementación - **Aserejex22**

#### `lib/widgets/paquete_card.dart`

**Responsable:** BojitaNoir

- Líneas 1-153: Card de paquete para lista

#### `lib/widgets/loading_widget.dart`

**Responsable:** Aserejex22

- Líneas 1-32: Widget de carga

#### `lib/widgets/error_widget.dart`

**Responsable:** Aserejex22

- Líneas 1-68: Widget de error

---

### 🛠️ Utilidades (Utils)

#### `lib/utils/app_theme.dart`

**Responsable:** Aserejex22

- Líneas 1-120: Tema personalizado de la app

#### `lib/utils/constants.dart`

**Responsable:** Aserejex22

- Líneas 1-45: Constantes globales

#### `lib/utils/validators.dart`

**Responsable:** JaimeCAST69

- Líneas 1-65: Validadores de formularios

---

### 🚀 Aplicación Principal

#### `lib/main.dart`

**Responsables:** JaimeCAST69 (inicial) + JonthanAyala (usuario provider)

- Líneas 1-5: Imports iniciales - **JaimeCAST69**
- Línea 6: Import UsuarioViewModel - **JonthanAyala**
- Líneas 7-28: Configuración base - **JaimeCAST69**
- Línea 30: Provider de UsuarioViewModel - **JonthanAyala**
- Líneas 31-129: SplashScreen y lógica - **JaimeCAST69**

---

## 📊 Secuencia Incremental de Desarrollo

### Fase 1: Configuración Base (Semana 1)

**Responsable:** JaimeCAST69

1. ✅ Configuración de `pubspec.yaml`
2. ✅ Estructura MVVM base
3. ✅ Tema y constantes

### Fase 2: Autenticación (Semana 2)

**Responsable:** JaimeCAST69

1. ✅ `usuario_model.dart`
2. ✅ `auth_service.dart`
3. ✅ `auth_viewmodel.dart`
4. ✅ `login_view.dart`
5. ✅ `validators.dart`

**Responsable:** JonthanAyala

1. ✅ `storage_service.dart`
2. ✅ `perfil_view.dart` (con logout)

### Fase 3: CRUD de Paquetes (Semana 3)

**Responsable:** BojitaNoir

1. ✅ `paquete_model.dart`
2. ✅ `paquete_service.dart`
3. ✅ `paquete_viewmodel.dart`
4. ✅ `lista_paquetes_view.dart`
5. ✅ `detalle_paquete_view.dart` (base)
6. ✅ `paquete_card.dart`

**Responsable:** Aserejex22

1. ✅ `crear_paquete_view.dart`
2. ✅ `local_storage_service.dart`
3. ✅ Widgets reutilizables (button, textfield, loading, error)

**Responsable:** JonthanAyala

1. ✅ `editar_paquete_view.dart`
2. ✅ Lógica de eliminación en `detalle_paquete_view.dart`

### Fase 4: Navegación y UI (Semana 4)

**Responsable:** Aserejex22

1. ✅ `home_view.dart` (base)
2. ✅ `app_theme.dart`
3. ✅ `constants.dart`
4. ✅ BottomNavigationBar

### Fase 5: Funcionalidades Avanzadas (Semana 5-6)

**Responsable:** Aserejex22

1. ✅ `qr_scanner_view.dart`
2. ✅ Integración de cámara en crear paquete
3. ✅ Botón QR en detalle de paquete

**Responsable:** JaimeCAST69

1. ✅ `notification_service.dart`
2. ✅ `database_service.dart` (SQLite)
3. ✅ `registro_view.dart`

**Responsable:** BojitaNoir

1. ✅ `ubicacion_model.dart`
2. ✅ `location_service.dart`
3. ✅ `mapa_view.dart` (sin Google Maps SDK)

### Fase 6: Gestión de Usuarios (Semana 7) - NUEVO

**Responsable:** JonthanAyala

1. ✅ `usuario_service.dart`
2. ✅ `usuario_viewmodel.dart`
3. ✅ `gestion_usuarios_view.dart`
4. ✅ `crear_usuario_view.dart`
5. ✅ `editar_usuario_view.dart`
6. ✅ Modificación de `home_view.dart` (pestaña usuarios)
7. ✅ Modificación de `main.dart` (provider)
8. ✅ Modificación de `registro_view.dart` (solo repartidores)

### Fase 7: Documentación (Continua)

**Responsable:** JonthanAyala

1. ✅ `FIREBASE_SETUP.md`
2. ✅ `MANUAL_USUARIO.md`
3. ✅ `CONFIGURACION_PERMISOS.md`
4. ✅ `README.md`

---

## 📈 Estadísticas por Integrante

### BojitaNoir

- **Archivos creados:** 7
- **Líneas de código:** ~1,200
- **Funcionalidades:** Lista paquetes, Detalle, Geolocalización, Mapas

### Aserejex22

- **Archivos creados:** 10
- **Líneas de código:** ~1,500
- **Funcionalidades:** UI/UX, Navegación, Cámara, QR Scanner, Widgets

### JaimeCAST69

- **Archivos creados:** 8
- **Líneas de código:** ~1,100
- **Funcionalidades:** Autenticación, Notificaciones, SQLite, Registro

### JonthanAyala

- **Archivos creados:** 9
- **Líneas de código:** ~1,300
- **Funcionalidades:** Sesión, Edición, Eliminación, Gestión Usuarios, Docs

---

## 🎯 Distribución de Responsabilidades

### Frontend (Vistas)

- **BojitaNoir:** 30% (Lista, Detalle, Mapa)
- **Aserejex22:** 35% (Crear, QR, Widgets, Navegación)
- **JaimeCAST69:** 20% (Login, Registro)
- **JonthanAyala:** 15% (Editar, Perfil, Gestión Usuarios)

### Backend (Servicios)

- **BojitaNoir:** 30% (Paquetes, Ubicación)
- **Aserejex22:** 15% (Almacenamiento local)
- **JaimeCAST69:** 35% (Auth, Notificaciones, SQLite)
- **JonthanAyala:** 20% (Storage, Usuarios)

### Arquitectura y Configuración

- **JaimeCAST69:** 40% (Configuración inicial, ViewModels)
- **Aserejex22:** 35% (Tema, Widgets, Navegación)
- **BojitaNoir:** 15% (Modelos, ViewModels)
- **JonthanAyala:** 10% (Integraciones, Docs)

---

## ✅ Checklist de Tareas Completadas

### BojitaNoir

- [x] #1 - Ver lista de paquetes
- [x] #11 - Ver detalle de paquete
- [x] #16 - Geolocalización y mapa

### Aserejex22

- [x] #5 - Navegación y diseño UI profesional
- [x] #10 - Crear paquete con foto
- [x] #13 - Cámara y escaneo QR

### JaimeCAST69

- [x] #6 - Pantalla de Login con validaciones
- [x] #15 - Notificaciones push
- [x] #17 - Persistencia local y sincronización
- [x] #7 - Pantalla de Registro con selección de rol

### JonthanAyala

- [x] #8 - Persistencia de sesión y logout
- [x] #12 - Editar paquete (solo admin/repartidor)
- [x] #14 - Eliminar paquete (solo admin)
- [x] #18 - Documentación viva
- [x] **NUEVO** - Gestión completa de usuarios

---

## 🏆 Contribuciones Destacadas

### BojitaNoir

- 🌟 Arquitectura MVVM de paquetes
- 🌟 Integración de geolocalización sin Google Maps SDK
- 🌟 Sistema de ubicación en tiempo real

### Aserejex22

- 🌟 Diseño UI/UX completo y consistente
- 🌟 Sistema de widgets reutilizables
- 🌟 Integración de cámara y QR scanner

### JaimeCAST69

- 🌟 Sistema completo de autenticación
- 🌟 Persistencia local con SQLite
- 🌟 Configuración base del proyecto

### JonthanAyala

- 🌟 Sistema de gestión de usuarios
- 🌟 Documentación completa del proyecto
- 🌟 Protecciones y validaciones de seguridad

---

**Última actualización:** Diciembre 2025  
**Proyecto:** Tucanes DMI 10A - Sistema de Gestión de Paquetería
