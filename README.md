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
- Login de usuarios
- Registro de usuarios
- Almacenamiento seguro de JWT

### ✅ Gestión de Motocicletas
- ✅ Registro de motocicletas
- ✅ **Listado de motocicletas del usuario** (GET /motorcycles)
- ✅ Perfil de motocicleta

### ✅ Historial de Mantenimientos
- ✅ Visualización de mantenimientos con diseño personalizado
- ✅ **Filtros avanzados:**
  - Filtro por fecha (día específico)
  - Filtro por rango de precio (mín/máx)
  - **Filtro por motocicleta** (motos reales del usuario desde backend)
- ✅ Detalle completo de cada mantenimiento en modal
- ✅ **Editar** mantenimientos (PUT /maintenance/{id})
- ✅ **Eliminar** mantenimientos con confirmación (DELETE /maintenance/{id})
- ✅ Integración con backend real (GET /maintenance/{motoId})
- ✅ **Verificación de autenticación** antes de cargar datos
- ⏳ Crear nuevos mantenimientos (POST /maintenance) - Pendiente

> 📄 **Documentación detallada:** Ver [BACKEND_INTEGRATION.md](./BACKEND_INTEGRATION.md)  
> 🔐 **Fix de autenticación:** Ver [AUTHENTICATION_FIX.md](./AUTHENTICATION_FIX.md)  
> 🏍️ **Fix filtro de motos:** Ver [MOTORCYCLE_FILTER_FIX.md](./MOTORCYCLE_FILTER_FIX.md)

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

### Endpoints Principales
- `POST /auth/login` - Autenticación
- `POST /auth/register` - Registro
- `GET /motorcycles` - Listar motocicletas
- `POST /motorcycles` - Registrar motocicleta
- `GET /maintenance-history` - Historial de mantenimientos

**Nota:** La feature de Historial de Mantenimientos actualmente usa datos mock para pruebas.

---

## 🧪 Modo de Prueba (Mock Data)

Algunas features incluyen datos de prueba para desarrollo sin backend:

### Historial de Mantenimientos
- 10 mantenimientos de ejemplo
- 5 motocicletas diferentes
- Filtros funcionales (fecha, precio, motocicleta)
- Ver: `lib/features/maintenance_history/TESTING_GUIDE.md`

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

### Estado Actual
- ✅ Autenticación funcional
- ✅ Registro de motocicletas
- ✅ Historial de mantenimientos (mock)
- 🚧 Integración completa con backend
- 🚧 Reportes
- 🚧 Alertas

### Próximos Pasos
- [ ] Completar integración con backend real
- [ ] Implementar módulo de reportes
- [ ] Implementar módulo de alertas
- [ ] Agregar tests unitarios
- [ ] Agregar tests de integración
- [ ] Mejorar manejo de errores
- [ ] Implementar caché local

---

## 📄 Licencia

Este proyecto es parte de un trabajo universitario para Gestión de Proyectos.

---

## 📞 Contacto

Para más información sobre el proyecto, contactar al equipo de desarrollo.

