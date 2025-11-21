# Feature: Recomendaciones de Mantenimiento

## Descripción
Esta funcionalidad proporciona recomendaciones de mantenimiento para motocicletas basadas en datos de expertos mecánicos. Incluye información sobre componentes comunes (aceite, frenos, llantas, filtros, batería), frecuencias sugeridas y explicaciones técnicas.

## Estructura del Feature

```
maintenance_recommendations/
├── domain/
│   ├── entities/
│   │   └── recommendation_entity.dart          # Entidad principal
│   ├── repositories/
│   │   └── recommendation_repository.dart      # Interfaz del repositorio
│   └── usecases/
│       ├── get_general_recommendations.dart    # Caso de uso: recomendaciones generales
│       └── get_motorcycle_recommendations.dart # Caso de uso: recomendaciones específicas
├── data/
│   ├── models/
│   │   └── recommendation_model.dart           # Modelo de datos con JSON
│   ├── datasources/
│   │   └── recommendation_remote_data_source.dart # Fuente de datos API
│   └── repositories/
│       └── recommendation_repository_impl.dart # Implementación del repositorio
└── presentation/
    ├── providers/
    │   └── recommendation_provider.dart        # State management
    ├── pages/
    │   └── maintenance_recommendations_page.dart # Página principal
    └── widgets/
        └── recommendation_card.dart            # Widget de tarjeta
```

## Endpoints del Backend

### 1. Recomendaciones Generales
```
GET /maintenance/recommendations/general
```
- **Headers**: `Authorization: Bearer {token}`
- **Respuesta**: Array de recomendaciones generales aplicables a cualquier motocicleta

### 2. Recomendaciones Específicas
```
GET /motorcycles/:id/maintenance-recommendations
```
- **Headers**: `Authorization: Bearer {token}`
- **Params**: `id` - ID de la motocicleta
- **Respuesta**: Array de recomendaciones personalizadas para la motocicleta específica

### Estructura de Datos (JSON)

```json
{
  "id": "string",
  "componentName": "string",           // "nombre_componente" en backend
  "category": "string",                // "categoria" en backend
  "description": "string",             // "descripcion" en backend
  "frequencyKm": 5000,                 // "frecuencia_km" en backend (opcional)
  "frequencyMonths": 6,                // "frecuencia_meses" en backend (opcional)
  "explanation": "string",             // "explicacion" en backend
  "iconName": "string",                // "icono_nombre" en backend
  "priority": "string",                // "prioridad" en backend
  "warningSignals": ["string", ...]   // "senales_advertencia" en backend (opcional)
}
```

## Uso

### 1. Navegación desde Lista de Motocicletas

Las tarjetas de motocicletas ahora incluyen un menú contextual con la opción "Recomendaciones":

```dart
// En list_motorcycle_page.dart
MotorcycleCard(
  motorcycle: motorcycle,
  onRecommendations: () => _openRecommendations(motorcycle),
  // ... otros callbacks
)
```

### 2. Navegación Programática

```dart
Navigator.of(context).pushNamed(
  '/maintenance-recommendations',
  arguments: {
    'motorcycleId': 'id-de-la-moto',
    'motorcycleName': 'Yamaha FZ-16',
  },
);
```

Para recomendaciones generales (sin moto específica):
```dart
Navigator.of(context).pushNamed('/maintenance-recommendations');
```

### 3. Uso del Provider

```dart
// Obtener el provider
final provider = Provider.of<MaintenanceRecommendationProvider>(context);

// Cargar recomendaciones generales
await provider.loadGeneralRecommendations();

// Cargar recomendaciones específicas
await provider.loadMotorcycleRecommendations('motorcycle-id');

// Filtrar por categoría
provider.setCategory('Aceite');

// Obtener lista filtrada
final recommendations = provider.filteredRecommendations;
```

## Características

### 1. Tarjeta de Recomendación (`RecommendationCard`)

- **Vista compacta**: Muestra nombre, categoría, descripción breve y frecuencias
- **Badges visuales**:
  - Prioridad: Alta (rojo), Media (naranja), Baja (verde)
  - Frecuencia en km: Badge azul con icono de velocímetro
  - Frecuencia en meses: Badge naranja con icono de calendario
- **Icono dinámico**: Basado en el tipo de componente
- **Interacción**: Tap para abrir diálogo con detalles completos

### 2. Diálogo de Detalles

Muestra información completa:
- Descripción extendida
- Explicación técnica detallada
- Señales de advertencia (si aplican)
- Todas las frecuencias recomendadas

### 3. Filtrado por Categoría

- Chips de filtro horizontal en la parte superior
- Categorías detectadas automáticamente de las recomendaciones cargadas
- Opción "Todas" para ver sin filtro

### 4. Pull to Refresh

Deslizar hacia abajo para recargar las recomendaciones

## Estados del Provider

```dart
enum RecommendationState {
  initial,  // Estado inicial
  loading,  // Cargando datos
  loaded,   // Datos cargados exitosamente
  error,    // Error al cargar
}
```

## Iconos Soportados

El widget mapea nombres de iconos a Material Icons:

- `oil_barrel`, `oil` → `Icons.oil_barrel`
- `brake`, `brakes` → `Icons.cancel`
- `tire`, `tires` → `Icons.tire_repair`
- `filter` → `Icons.filter_alt`
- `battery` → `Icons.battery_charging_full`
- `chain` → `Icons.link`
- Por defecto → `Icons.build`

## Prioridades

Valores esperados (case-insensitive):
- `alta` / `high` → Badge rojo
- `media` / `medium` → Badge naranja
- `baja` / `low` → Badge verde

## Integración en `main.dart`

El provider está registrado globalmente:

```dart
MultiProvider(
  providers: [
    // ... otros providers
    ChangeNotifierProvider(
      create: (context) {
        final repository = MaintenanceRecommendationRepositoryImpl(
          remoteDataSource: RecommendationRemoteDataSourceImpl(),
        );
        return MaintenanceRecommendationProvider(
          getGeneralRecommendationsUseCase: GetGeneralRecommendations(repository),
          getMotorcycleRecommendationsUseCase: GetMotorcycleRecommendations(repository),
        );
      },
    ),
  ],
  child: MaterialApp(...),
)
```

Ruta registrada:
```dart
routes: {
  '/maintenance-recommendations': (context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return MaintenanceRecommendationsPage(
      motorcycleId: args?['motorcycleId'] as String?,
      motorcycleName: args?['motorcycleName'] as String?,
    );
  },
  // ... otras rutas
}
```

## Testing

Para probar la funcionalidad:

1. **Backend Mock**: Asegúrate de que tu backend tenga datos de prueba en los endpoints
2. **Navegación**: Desde la lista de motocicletas, toca el menú (⋮) y selecciona "Recomendaciones"
3. **Filtros**: Usa los chips de categoría para filtrar
4. **Detalles**: Toca cualquier tarjeta para ver detalles completos

## Ejemplo de Datos de Prueba (Backend)

```json
[
  {
    "id": "1",
    "nombre_componente": "Aceite de Motor",
    "categoria": "Aceite",
    "descripcion": "Cambio de aceite lubricante del motor",
    "frecuencia_km": 5000,
    "frecuencia_meses": 6,
    "explicacion": "El aceite lubrica las partes móviles del motor, reduciendo fricción y desgaste. Con el tiempo pierde sus propiedades y debe ser reemplazado.",
    "icono_nombre": "oil",
    "prioridad": "alta",
    "senales_advertencia": [
      "Aceite oscuro o negro",
      "Ruidos extraños del motor",
      "Luz de presión de aceite encendida"
    ]
  },
  {
    "id": "2",
    "nombre_componente": "Pastillas de Freno",
    "categoria": "Frenos",
    "descripcion": "Inspección y cambio de pastillas de freno",
    "frecuencia_km": 15000,
    "frecuencia_meses": 12,
    "explicacion": "Las pastillas de freno se desgastan con el uso. Un desgaste excesivo reduce la eficacia del frenado y puede dañar los discos.",
    "icono_nombre": "brake",
    "prioridad": "alta",
    "senales_advertencia": [
      "Chirridos al frenar",
      "Frenado menos efectivo",
      "Vibración en la palanca"
    ]
  }
]
```

## Diseño Visual

- **Color primario**: `#2196F3` (azul consistente con el tema de la app)
- **Elevación de tarjetas**: 2
- **Bordes redondeados**: 12px
- **Tipografía**: Poppins (fuente de la app)
- **Espaciado**: Padding de 16px en tarjetas y 8px en elementos internos

## Próximas Mejoras

- [ ] Búsqueda por nombre de componente
- [ ] Ordenamiento (por prioridad, frecuencia, nombre)
- [ ] Favoritos/guardados
- [ ] Notificaciones basadas en kilometraje actual
- [ ] Historial de mantenimientos relacionados
- [ ] Compartir recomendaciones
- [ ] Modo offline con caché local
