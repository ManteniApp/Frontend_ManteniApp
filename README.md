# 🛠️ ManteniApp - Frontend

**ManteniApp** es una aplicación móvil desarrollada en **Flutter** que permite la gestión y seguimiento de mantenimientos de motocicletas de forma práctica y moderna.  
Su diseño sigue una arquitectura **Clean Architecture**, promoviendo la escalabilidad, el orden y la reutilización del código.

---

## 📱 Tecnologías Utilizadas

- **Flutter** (SDK ^3.9.2)
- **Dart** (lenguaje principal)
- **Material Design** (UI/UX)
- **Provider** (State Management)
- **Clean Architecture** (Arquitectura)
- **HTTP** (Comunicación con backend)

---

## 🎯 Funcionalidades Implementadas

### ✅ Autenticación
- ✅ Login de usuarios (JWT)
- ✅ Registro de usuarios
- ✅ Autenticación con Google
- ✅ Recuperación de contraseña
- ✅ Almacenamiento seguro de JWT tokens
- ✅ Deep linking para restablecer contraseña

### ✅ Gestión de Motocicletas
- ✅ Registro de motocicletas con todos los datos
- ✅ **Listado de motocicletas del usuario** (GET /motorcycles)
- ✅ **Edición de motocicletas** (PUT /motorcycles/{id})
- ✅ **Eliminación de motocicletas** (DELETE /motorcycles/{id})
- ✅ Perfil detallado de motocicleta
- ✅ **Soporte para imágenes de motos:**
  - Carga desde URL externa (`imagen_url`)
  - Carga desde servidor local (`imagen_local`)
  - Fallback automático a placeholder
  - Visualización en todas las vistas (tarjetas, perfiles, selectores)

### ✅ Historial de Mantenimientos
- ✅ Visualización de mantenimientos con diseño personalizado
- ✅ **Filtros avanzados:**
  - Filtro por fecha (día específico)
  - Filtro por rango de precio (mín/máx)
  - **Filtro por motocicleta** (motos reales del usuario desde backend)
- ✅ Detalle completo de cada mantenimiento en modal interactivo
- ✅ **Editar mantenimientos** (PUT /maintenance/{id})
- ✅ **Eliminar mantenimientos** con confirmación (DELETE /maintenance/{id})
- ✅ Integración con backend real (GET /maintenance/{motoId})
- ✅ **Verificación de autenticación** antes de cargar datos
- ✅ Pull-to-refresh para actualizar datos

### ✅ Registro de Mantenimientos
- ✅ **Crear nuevos mantenimientos** (POST /maintenance)
- ✅ Formulario completo con validaciones
- ✅ Selector de motocicleta con imágenes
- ✅ Campos: tipo, fecha, kilometraje, costo, descripción
- ✅ Integración con backend real

### ✅ Reportes de Mantenimiento
- ✅ **Vista de reporte completo por motocicleta**
- ✅ Métricas clave:
  - Total de mantenimientos
  - Costo total y promedio
  - Última fecha de mantenimiento (calculada automáticamente)
- ✅ **Servicios más frecuentes** con estadísticas de costo
- ✅ **Lista detallada de mantenimientos** con tarjetas interactivas
- ✅ **Exportación a PDF** con autenticación
- ✅ Soporte multiplataforma (Web y Android/iOS)
- ✅ Selector de motocicleta con imágenes
- ✅ Botón de actualización manual
- ✅ Integración completa con backend (GET /maintenance-summary)

### ✅ Recomendaciones de Mantenimiento
- ✅ Recomendaciones generales de mantenimiento
- ✅ Recomendaciones técnicas especializadas
- ✅ Recomendaciones específicas por motocicleta
- ✅ Sistema de filtrado por categorías
- ✅ Tarjetas informativas con iconos
- ✅ Integración con backend real

### ✅ Perfil de Usuario
- ✅ Visualización de datos del usuario
- ✅ Edición de información personal
- ✅ Cambio de contraseña
- ✅ Actualización de foto de perfil
- ✅ Cierre de sesión

---

## 📂 Estructura del Proyecto

```
lib/
├── main.dart                      # Punto de entrada
├── core/                          # Funcionalidades compartidas
│   ├── layout/
│   │   └── main_layout.dart      # Layout principal con menú
│   ├── theme/
│   │   └── app_theme.dart        # Tema de la aplicación
│   └── network/
│       ├── api_client.dart       # Cliente HTTP
│       └── api_config.dart       # Configuración de endpoints
├── features/                      # Features por módulo
│   ├── auth_1/                   # Autenticación
│   │   ├── domain/
│   │   ├── data/
│   │   └── presentation/
│   ├── motorcycles/              # Gestión de motocicletas
│   │   ├── domain/
│   │   ├── data/
│   │   └── presentation/
│   └── maintenance_history/      # Historial de mantenimientos
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       ├── data/
│       │   ├── models/
│       │   ├── datasources/
│       │   └── repositories/
│       └── presentation/
│           ├── pages/
│           ├── widgets/
│           └── providers/
```

---

## 🚀 Configuración e Instalación

### Requisitos Previos
- Flutter SDK ^3.9.2
- Dart SDK
- Android Studio / VS Code
- Emulador Android o dispositivo físico

### Instalación

1. **Clonar el repositorio**
```bash
git clone https://github.com/ManteniApp/Frontend_ManteniApp.git
cd Frontend_ManteniApp
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Ejecutar la aplicación**
```bash
flutter run
```

---

## 🔧 Dependencias Principales

```yaml
dependencies:
  flutter_bloc: ^9.1.1          # State management
  provider: ^6.1.1              # State management alternativo
  equatable: ^2.0.7             # Comparación de objetos
  http: ^1.5.0                  # Cliente HTTP
  get_it: ^8.2.0                # Inyección de dependencias
  image_picker: ^1.1.1          # Selector de imágenes
  salomon_bottom_bar: ^3.3.2    # Menú inferior
  flutter_secure_storage: ^9.2.2 # Almacenamiento seguro (JWT)
  intl: ^0.19.0                 # Internacionalización y formateo
```

---

## 🌐 Configuración del Backend

La aplicación se conecta a un backend NestJS en:
```
http://localhost:3000
```

### 🔐 Autenticación
Todos los endpoints (excepto login y register) requieren autenticación JWT mediante header:
```
Authorization: Bearer {token}
```

### 📡 Endpoints Implementados

#### Autenticación
- `POST /auth/login` - Iniciar sesión (retorna JWT)
- `POST /auth/register` - Registrar nuevo usuario
- `POST /auth/google` - Autenticación con Google
- `POST /auth/forgot-password` - Solicitar restablecimiento de contraseña
- `POST /auth/reset-password` - Restablecer contraseña

#### Motocicletas
- `GET /motorcycles` - Listar motocicletas del usuario autenticado
- `GET /motorcycles/{id}` - Obtener motocicleta por ID
- `POST /motorcycles` - Registrar nueva motocicleta
- `PUT /motorcycles/{id}` - Actualizar motocicleta
- `DELETE /motorcycles/{id}` - Eliminar motocicleta

**Estructura de Moto:**
```json
{
  "id": 10,
  "marca": "Yamaha",
  "modelo": "MT-07",
  "placa": "ABC123",
  "año": 2024,
  "kilometraje": 5000,
  "cilindraje": 689,
  "imagen_url": "https://ejemplo.com/foto.jpg",
  "imagen_local": "/uploads/motorcycles/foto.jpg"
}
```

#### Mantenimientos
- `GET /maintenance/{motoId}` - Historial de mantenimientos por moto
- `GET /maintenance/detail/{id}` - Detalle de un mantenimiento
- `POST /maintenance` - Crear nuevo mantenimiento
- `PUT /maintenance/{id}` - Actualizar mantenimiento
- `DELETE /maintenance/{id}` - Eliminar mantenimiento

**Estructura de Mantenimiento:**
```json
{
  "id": 62,
  "moto_id": 10,
  "fecha": "2025-12-08T05:00:00.000Z",
  "tipo": "Cambio de aceite",
  "descripcion": "Aceite sintético 10W-40",
  "kilometraje": 5000,
  "costo": "50000.00"
}
```

#### Reportes
- `GET /maintenance-summary?motoId={id}` - Resumen de mantenimientos
  - Retorna: totalMantenimientos, costoTotal, costoPromedio, estadisticasPorTipo, mantenimientos[]
- `GET /maintenance-summary/pdf?motoId={id}` - Exportar reporte a PDF
  - Retorna: Archivo PDF binario

#### Recomendaciones
- `GET /recommendations/general` - Recomendaciones generales
- `GET /recommendations/technical` - Recomendaciones técnicas
- `GET /recommendations/{motorcycleId}` - Recomendaciones por moto

#### Usuario
- `GET /users/profile` - Obtener perfil del usuario
- `PUT /users/profile` - Actualizar perfil
- `PUT /users/change-password` - Cambiar contraseña
- `POST /users/profile/image` - Actualizar foto de perfil

### 🖼️ Manejo de Imágenes

El backend envía imágenes de motos mediante dos campos:

1. **`imagen_url`**: URL externa directa (ej: Cloudinary, S3)
2. **`imagen_local`**: Ruta relativa en el servidor (ej: `/uploads/motorcycles/foto.jpg`)

**Prioridad de carga en el frontend:**
1. Si existe `imagen_local` → se usa con prefijo `http://localhost:3000`
2. Si no, se usa `imagen_url`
3. Si ninguno existe → se muestra placeholder

**Ejemplo de uso:**
```dart
// El modelo automáticamente construye la URL correcta
final imageUrl = motorcycle.imageUrl; // Ya incluye el prefijo si es local
```

---

## 🧪 Estado de Integración con Backend

### ✅ Completamente Integrado (Datos Reales)
- ✅ Autenticación (Login, Register, Google Auth)
- ✅ Gestión de motocicletas (CRUD completo)
- ✅ Historial de mantenimientos (CRUD completo)
- ✅ Registro de mantenimientos
- ✅ Reportes de mantenimiento con exportación PDF
- ✅ Recomendaciones de mantenimiento
- ✅ Perfil de usuario

### 📊 Todos los datos mostrados provienen del backend real
No se están usando datos mock en producción. La aplicación está completamente conectada al backend NestJS.

---

## 🏗️ Arquitectura Clean Architecture

El proyecto sigue los principios de Clean Architecture dividida en 3 capas:

### 1. Domain (Dominio)
- **Entities**: Modelos de negocio puros
- **Repositories**: Contratos de acceso a datos
- **Use Cases**: Lógica de negocio

### 2. Data (Datos)
- **Models**: Modelos con serialización JSON
- **Data Sources**: Fuentes de datos (API, local)
- **Repository Impl**: Implementación de repositorios

### 3. Presentation (Presentación)
- **Pages**: Pantallas de la app
- **Widgets**: Componentes reutilizables
- **Providers/BLoC**: Manejo de estado

---

## 🎨 Guía de Estilos

### Colores Principales
- **Primary**: `#2196F3` (Azul)
- **Secondary**: `#1976D2` (Azul oscuro)
- **Background**: `#F5F5F5` (Gris claro)
- **Success**: `#43A047` (Verde)
- **Warning**: `#FFB300` (Amarillo)

### Tipografía
- **Font Family**: Poppins
- **Títulos**: Bold, 20-24px
- **Subtítulos**: SemiBold, 16-18px
- **Texto**: Regular, 14-16px

---

## 📱 Navegación

La aplicación utiliza un sistema de navegación basado en rutas:

```dart
routes: {
  '/home': MainLayout(),
  '/login': LoginPage(),
  '/register': RegisterPage(),
  '/register-motorcycle': RegisterMotorcyclePage(),
  '/maintenance-history': MaintenanceHistoryPage(),
}
```

**Menú Principal:**
1. 🏠 Inicio
2. 🏍️ Motos
3. 🔧 Historial
4. 🔔 Alertas

---

## 👥 Equipo de Desarrollo

- Frontend: Flutter/Dart
- Backend: NestJS/TypeScript
- Database: PostgreSQL

---

## 📝 Notas de Desarrollo

### Estado Actual (Actualizado: Diciembre 2025)
- ✅ Autenticación completa con JWT y Google
- ✅ CRUD completo de motocicletas con imágenes
- ✅ CRUD completo de mantenimientos
- ✅ Sistema de reportes con exportación PDF
- ✅ Recomendaciones de mantenimiento
- ✅ Perfil de usuario con foto
- ✅ Integración completa con backend NestJS
- ✅ Soporte multiplataforma (Web, Android, iOS)
- 🚧 Módulo de alertas y notificaciones

### 🎯 Próximos Pasos
- [ ] Implementar módulo de alertas y notificaciones push
- [ ] Agregar tests unitarios y de integración
- [ ] Implementar caché local para offline support
- [ ] Mejorar manejo de errores con retry logic
- [ ] Agregar analytics y crash reporting
- [ ] Optimizar rendimiento de imágenes
- [ ] Implementar búsqueda avanzada de mantenimientos
- [ ] Agregar gráficas de estadísticas
- [ ] Soporte para múltiples idiomas (i18n)
- [ ] Modo oscuro

### 🔧 Mejoras Técnicas Pendientes
- [ ] Implementar refresh tokens para JWT
- [ ] Agregar paginación en listas largas
- [ ] Optimizar carga de imágenes con caché
- [ ] Implementar skeleton loaders
- [ ] Mejorar accesibilidad (a11y)
- [ ] Agregar animaciones de transición

---

## 📄 Licencia

Este proyecto es parte de un trabajo universitario para Gestión de Proyectos.

---

## 📞 Contacto

Para más información sobre el proyecto, contactar al equipo de desarrollo.

