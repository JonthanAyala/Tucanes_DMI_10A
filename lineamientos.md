# 📋 Lineamientos Generales del Proyecto Integrador

<aside>
📋

**Lineamientos Obligatorios para el Proyecto Integrador**

**Unidad I: Definición del proceso de desarrollo móvil**

**Todos los equipos deben cumplir estos requisitos mínimos para asegurar consistencia en la complejidad de los proyectos**

</aside>

---

## 🎯 Objetivos del Proyecto Integrador

<aside>
🎯

**El proyecto integrador debe demostrar la aplicación práctica de todos los conceptos aprendidos en la Unidad I, creando una aplicación móvil completa y profesional que integre metodologías ágiles, arquitectura MVVM, y tecnologías modernas de desarrollo móvil.**

</aside>

---

## 📋 Requisitos Obligatorios para Todos los Equipos

<aside>
⚠️

**IMPORTANTE: Todos estos requisitos son OBLIGATORIOS. No se aceptarán proyectos que no cumplan con al menos el 80% de estos lineamientos.**

</aside>

### **🏗️ Arquitectura y Framework**

- [ ]  **Flutter como Framework Principal**
    - ✅ Desarrollo multiplataforma (iOS + Android)
    - ✅ Uso correcto de Widgets (Stateless/Stateful)
    - ✅ Arquitectura Material Design
- [ ]  **Patrón MVVM Obligatorio**
    - ✅ Separación clara: Model-View-ViewModel
    - ✅ ViewModels independientes de la UI
    - ✅ Models con lógica de negocio
    - ✅ Views enfocadas únicamente en presentación

### **☁️ Backend y Servicios en la Nube**

- [ ]  **Backend Obligatoriamente en la Nube**
    - ✅ AWS, Firebase, o similar (NO [localhost](http://localhost))
    - ✅ APIs RESTful o GraphQL
    - ✅ Base de datos en la nube
    - ✅ Servicios escalables y seguros
- [ ]  **Consumo de APIs con Dio**
    - ✅ Configuración completa de Dio
    - ✅ Manejo de headers de autenticación
    - ✅ Interceptors para logging y errores
    - ✅ Timeouts y retry logic

### **🔐 Autenticación de Usuarios (Mínimo 2 Pantallas)**

- [ ]  **Sistema de Autenticación Completo**
    - ✅ **Pantalla de Login** con validación
    - ✅ **Pantalla de Registro** con confirmación
    - ✅ Gestión de sesiones (tokens JWT)
    - ✅ Validación de campos en tiempo real
    - ✅ Manejo de errores de autenticación
    - ✅ Persistencia de sesión (SharedPreferences)
    - ✅ Logout funcional

### **📊 Gestión de Entidad Principal (CRUD Completo - Mínimo 2-3 Pantallas)**

- [ ]  **Entidad Principal con CRUD Completo**
    - ✅ **Pantalla de Lista** (Read - mostrar todos)
    - ✅ **Pantalla de Creación** (Create - agregar nuevo)
    - ✅ **Pantalla de Edición** (Update - modificar existente)
    - ✅ **Pantalla de Detalle** (Read - ver uno específico)
    - ✅ **Funcionalidad de Eliminación** (Delete - con confirmación)
    - ✅ Validaciones en formularios
    - ✅ Estados de carga y manejo de errores

### **💾 Persistencia de Datos**

- [ ]  **Almacenamiento Local**
    - ✅ SharedPreferences para datos simples
    - ✅ SQLite para datos complejos (opcional avanzado)
    - ✅ Cache de datos para offline
- [ ]  **Almacenamiento en la Nube**
    - ✅ Sincronización automática con backend
    - ✅ Backup de datos importantes
    - ✅ Manejo de conflictos de sincronización

### **🎨 Interfaz de Usuario (UI) Limpia y Funcional**

- [ ]  **Diseño UI/UX Profesional**
    - ✅ Tema personalizado consistente
    - ✅ Navegación intuitiva (BottomNavigationBar o Drawer)
    - ✅ Layouts responsivos
    - ✅ Animaciones sutiles y funcionales
    - ✅ Estados de carga (CircularProgressIndicator)
    - ✅ Manejo de errores con SnackBars/Dialogs
    - ✅ Iconografía consistente (Material Icons)

### **📸 Integración de Cámara**

- [ ]  **Funcionalidad de Cámara**
    - ✅ Permisos de cámara solicitados correctamente
    - ✅ Captura de fotos desde galería y cámara
    - ✅ Vista previa de imagen capturada
    - ✅ Compresión de imágenes para optimización
    - ✅ Almacenamiento local y subida a la nube
    - ✅ Manejo de errores de permisos

### **📍 Uso de Ubicación (Al menos 1 Funcionalidad)**

- [ ]  **Integración de Geolocalización**
    - ✅ Permisos de ubicación configurados
    - ✅ Obtención de coordenadas GPS
    - ✅ Mostrar ubicación en mapa (Google Maps)
    - ✅ Funcionalidad útil (ej: ubicación de entidad, check-in)
    - ✅ Manejo de errores de GPS
    - ✅ Cache de ubicación para offline

### **🔔 Notificaciones Push con Firebase**

- [ ]  **Sistema de Notificaciones**
    - ✅ Configuración completa de Firebase
    - ✅ Token de dispositivo registrado
    - ✅ Notificaciones push desde backend
    - ✅ Manejo de notificaciones en foreground/background
    - ✅ Navegación desde notificación
    - ✅ Personalización de notificaciones

---

## 📊 Niveles de Complejidad por Equipo

<aside>
📈

**Los equipos pueden elegir su nivel de complejidad, pero todos deben cumplir los requisitos mínimos.**

</aside>

### **🟢 Nivel Básico (Cumple requisitos mínimos)**

- ✅ Todos los requisitos obligatorios
- ✅ Funcionalidad básica pero completa
- ✅ UI funcional y usable
- ✅ Documentación básica

### **🟡 Nivel Intermedio (Funcionalidades adicionales)**

- ✅ Todos los requisitos básicos
- ✅ Al menos 2 funcionalidades avanzadas
- ✅ UI pulida con animaciones
- ✅ Testing básico implementado
- ✅ Documentación completa

### **🟠 Nivel Avanzado (Proyecto excepcional)**

- ✅ Todos los requisitos anteriores
- ✅ Múltiples entidades con relaciones
- ✅ Arquitectura compleja (Clean Architecture)
- ✅ Testing completo (Unit + Widget)
- ✅ CI/CD básico implementado
- ✅ Documentación técnica completa

---

## ⏰ Cronograma del Proyecto Integrador

| **Fase** | **Duración** | **Entregables** | **Evaluación** |
| --- | --- | --- | --- |
| **📋 Planificación** | Semanas 1-2 | Documento de requerimientos, mockups, arquitectura | Rúbrica de planificación |
| **🔧 Desarrollo Backend** | Semanas 3-4 | APIs funcionales, base de datos en nube | Demo de APIs |
| **📱 Desarrollo Frontend** | Semanas 5-8 | App Flutter completa con MVVM | Presentación intermedia |
| **🧪 Testing y Optimización** | Semanas 9-10 | Testing completo, optimizaciones | Reporte de testing |
| **🚀 Despliegue Final** | Semanas 11-12 | App en producción, documentación | Presentación final |

---

## 📋 Criterios de Evaluación

<aside>
📊

**La evaluación se basa en el cumplimiento de requisitos y calidad de implementación**

</aside>

### **📱 Funcionalidad (40%)**

- ✅ Cumplimiento de requisitos obligatorios: 25%
- ✅ Funcionalidad completa y estable: 10%
- ✅ Manejo de errores y edge cases: 5%

### **🏗️ Arquitectura (25%)**

- ✅ Implementación correcta de MVVM: 10%
- ✅ Separación de responsabilidades: 7%
- ✅ Clean Code y buenas prácticas: 8%

### **🎨 UI/UX (15%)**

- ✅ Interfaz intuitiva y atractiva: 7%
- ✅ Experiencia de usuario fluida: 5%
- ✅ Diseño responsive: 3%

### **☁️ Backend/Integración (10%)**

- ✅ APIs bien diseñadas: 5%
- ✅ Integración correcta con Dio: 3%
- ✅ Seguridad implementada: 2%

### **📚 Documentación (10%)**

- ✅ README completo: 4%
- ✅ Documentación técnica: 3%
- ✅ Guía de usuario: 3%

---

## 🚨 Reglas Importantes

<aside>
⚠️

**Reglas que TODOS los equipos deben seguir estrictamente**

</aside>

### **✅ Obligatorio**

- [ ]  **Metodología Ágil**: Scrum con sprints semanales
- [ ]  **Control de Versiones**: Git con GitHub/GitLab
- [ ]  **Documentación**: Actualizada semanalmente
- [ ]  **Revisiones**: Code reviews obligatorios
- [ ]  **Testing**: Al menos testing básico implementado

### **❌ Prohibido**

- ❌ Copiar código de otros equipos
- ❌ Usar templates sin modificar
- ❌ Desarrollar sin arquitectura MVVM
- ❌ No documentar decisiones técnicas
- ❌ No hacer commits regulares

---

## 🏆 Requisitos de Entrega Final

<aside>
🏆

**Para considerar el proyecto como completado**

</aside>

### **📦 Repositorio**

- ✅ **Código fuente** completo y funcional
- ✅ [**README.md**](http://README.md) detallado con instrucciones
- ✅ **Documentación técnica** (arquitectura, APIs)
- ✅ **Commits** regulares con mensajes descriptivos

### **📱 Aplicación**

- ✅ **APK/IPA** generados y funcionales
- ✅ **APIs** desplegadas y accesibles
- ✅ **Base de datos** con datos de prueba
- ✅ **Configuración** de Firebase completa

### **📋 Documentación**

- ✅ **Manual de usuario** con screenshots
- ✅ **Guía de instalación** paso a paso
- ✅ **Video demo** de funcionalidades
- ✅ **Retrospectiva** del proceso de desarrollo

### **📊 Presentación**

- ✅ **Demo funcional** de toda la aplicación
- ✅ **Explicación** de arquitectura implementada
- ✅ **Lecciones aprendidas** y desafíos enfrentados
- ✅ **Preguntas y respuestas** con el docente

---

## 💡 Consejos para el Éxito

<aside>
💡

**Recomendaciones basadas en experiencias anteriores**

</aside>

### **🎯 Planificación**

- ✅ **Definir alcance** realista desde el inicio
- ✅ **Prototipar** la UI antes de codificar
- ✅ **Planificar arquitectura** antes de empezar
- ✅ **Identificar riesgos** y plan de contingencia

### **🔧 Desarrollo**

- ✅ **Commits diarios** con funcionalidad completa
- ✅ **Testing continuo** de cada funcionalidad
- ✅ **Code reviews** semanales
- ✅ **Documentar** decisiones técnicas importantes

### **🚨 Manejo de Riesgos**

- ✅ **Backend primero**: Desarrollar APIs antes que la app
- ✅ **Funcionalidades críticas**: Autenticación y CRUD primero
- ✅ **Testing temprano**: Evitar bugs acumulados
- ✅ **Backup regular**: Commits y backups de base de datos

---

<aside>
🚀

**¡Éxito en tu Proyecto Integrador!**

Estos lineamientos aseguran que todos los equipos desarrollen proyectos de similar complejidad, permitiendo una evaluación justa y preparando a todos los estudiantes con habilidades reales de desarrollo móvil profesional. ¡Manos a la obra!

</aside>

[📊 Rúbricas de Evaluación del Proyecto](https://www.notion.so/R-bricas-de-Evaluaci-n-del-Proyecto-2721f4e23f2f812d94c7df21ee29e460?pvs=21)