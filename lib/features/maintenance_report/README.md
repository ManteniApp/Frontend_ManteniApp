# Feature: Reporte de Mantenimientos

## 📋 Descripción
Este feature permite a los usuarios ver un reporte resumen de sus mantenimientos realizados, proporcionando una visión general del estado y los gastos de su motocicleta.

## ✨ Funcionalidades Implementadas

### Frontend (Completado ✅)
- ✅ Pantalla "Reporte de mantenimientos"
- ✅ Métricas principales (total de mantenimientos, costo total, costo promedio)
- ✅ Visualización de la fecha del último mantenimiento
- ✅ Gráfico de servicios más frecuentes con barras de progreso
- ✅ Filtros por rango de fechas
- ✅ **Selector de motocicleta** (Ver reporte general o por moto específica)
- ✅ Botón de descarga/exportación a PDF
- ✅ Mensajes de estado (sin datos, cargando, error)
- ✅ Actualización automática mediante RefreshIndicator
- ✅ Integración completa con la navegación de la app
- ✅ **Datos mockeados para desarrollo (hasta que backend esté listo)**

## 🏍️ Selector de Motocicleta

El reporte es **versátil** y permite ver estadísticas de dos formas:

### 📊 Reporte General (Predeterminado)
- Muestra estadísticas consolidadas de **todas las motocicletas** del usuario
- Ideal para ver el panorama completo de gastos y mantenimientos

### 🔍 Reporte Individual
- Filtra los datos por una motocicleta específica
- Selecciona desde el chip selector en la parte superior
- Las estadísticas se actualizan automáticamente

**Uso:**
1. Presiona el chip selector "Todas las motocicletas" en la parte superior
2. Selecciona una moto específica o "Todas las motocicletas"
3. El reporte se actualiza automáticamente

## 🎭 Modo MOCK Activado

Actualmente el feature está usando **datos simulados** porque el backend aún no ha implementado los endpoints necesarios.

### ⚙️ Cómo cambiar entre MOCK y REAL:

**Archivo:** `lib/features/maintenance_report/data/repositories/maintenance_report_repository_impl.dart`

```dart
/// ⚠️ CONFIGURACIÓN: Cambiar a false cuando el backend esté listo
const bool USE_MOCK_DATA = true;  // ← Cambiar a false para usar datos reales
```

**Cuando cambiar a datos reales:**
1. El backend implementa los endpoints (SCRUM-209, SCRUM-210)
2. Cambiar `USE_MOCK_DATA = false` en el archivo mencionado
3. ¡Listo! El feature usará automáticamente los datos del backend

### Backend (Pendiente ⏳)
⚠️ **El backend debe implementar los siguientes endpoints:**

#### 1. GET `/maintenance/report`
Obtiene el resumen de mantenimientos con filtros opcionales.

**Query Parameters:**
- `startDate` (opcional): Fecha de inicio en formato ISO 8601
- `endDate` (opcional): Fecha de fin en formato ISO 8601
- `motorcycleId` (opcional): ID de la motocicleta para filtrar

**Respuesta esperada (200 OK):**
```json
{
  "totalMaintenances": 15,
  "totalCost": 1500.50,
  "averageCost": 100.03,
  "mostFrequentServices": [
    {
      "serviceName": "Cambio de aceite",
      "count": 5
    },
    {
      "serviceName": "Revisión de frenos",
      "count": 3
    }
  ],
  "lastMaintenanceDate": "2025-11-10T12:00:00Z",
  "startDate": "2025-01-01T00:00:00Z",
  "endDate": "2025-11-15T23:59:59Z"
}
```

**Respuesta sin datos (404):**
El frontend manejará automáticamente este caso y mostrará el mensaje "Aún no tienes mantenimientos registrados"

#### 2. GET `/maintenance/report/pdf`
Genera y devuelve un PDF con el reporte.

**Query Parameters:**
- `startDate` (opcional): Fecha de inicio
- `endDate` (opcional): Fecha de fin
- `motorcycleId` (opcional): ID de la motocicleta

**Respuesta esperada (200 OK):**
```json
{
  "pdfUrl": "https://api.example.com/downloads/report_123456.pdf",
  "url": "https://api.example.com/downloads/report_123456.pdf"
}
```

## 📁 Estructura del Feature

```
lib/features/maintenance_report/
├── data/
│   ├── datasources/
│   │   └── maintenance_report_remote_data_source.dart
│   ├── models/
│   │   └── maintenance_report_model.dart
│   └── repositories/
│       └── maintenance_report_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── maintenance_report_entity.dart
│   ├── repositories/
│   │   └── maintenance_report_repository.dart
│   └── usecases/
│       ├── export_report_to_pdf.dart
│       └── get_maintenance_report.dart
└── presentation/
    ├── pages/
    │   └── maintenance_report_page.dart
    ├── providers/
    │   └── maintenance_report_provider.dart
    └── widgets/
        ├── date_range_filter_modal.dart
        ├── frequent_services_card.dart
        ├── metric_card.dart
        └── report_states.dart
```

## 🎨 Componentes de UI

### MetricCard
Tarjeta para mostrar métricas individuales con icono y valor.

### FrequentServicesCard
Tarjeta que muestra los servicios más frecuentes con barras de progreso indicando la frecuencia relativa.

### DateRangeFilterModal
Modal para seleccionar rango de fechas con validación automática.

### Report States
- `EmptyReportState`: Mensaje cuando no hay mantenimientos
- `LoadingReportState`: Indicador de carga
- `ErrorReportState`: Mensaje de error con botón de reintento

## 🚀 Cómo Usar

### Para el Usuario Final
1. Navegar a "Historial de Mantenimientos"
2. Tocar el ícono de reporte (📊) en la parte superior derecha
3. Ver el resumen de mantenimientos
4. (Opcional) Aplicar filtros de fecha
5. (Opcional) Exportar a PDF

### Para Desarrolladores

#### Acceder al Provider
```dart
final reportProvider = context.read<MaintenanceReportProvider>();
```

#### Cargar el Reporte
```dart
await reportProvider.loadReport();
```

#### Aplicar Filtros
```dart
await reportProvider.setDateRange(startDate, endDate);
```

#### Exportar a PDF
```dart
await reportProvider.exportToPdf();
```

## 🔄 Flujo de Datos

1. **Usuario accede al reporte** → `MaintenanceReportPage`
2. **Se carga automáticamente** → `MaintenanceReportProvider.loadReport()`
3. **Provider llama al caso de uso** → `GetMaintenanceReport`
4. **Caso de uso consulta repositorio** → `MaintenanceReportRepository`
5. **Repositorio obtiene datos** → `MaintenanceReportRemoteDataSource`
6. **Data source hace petición HTTP** → Backend API
7. **Datos se parsean** → `MaintenanceReportModel`
8. **UI se actualiza** → Muestra métricas y gráficos

## 🎯 Criterios de Aceptación Cumplidos

- ✅ El sistema muestra un resumen con cantidad total, coste total y promedio
- ✅ Muestra servicios más frecuentes
- ✅ Muestra fecha del último mantenimiento
- ✅ El usuario puede filtrar por rango de fechas
- ✅ El reporte se muestra en formato visual (tarjetas)
- ✅ Botón para exportar/guardar en PDF (integración lista, pendiente backend)
- ✅ Mensaje "Aún no tienes mantenimientos registrados" cuando no hay datos
- ✅ Los datos se actualizan con pull-to-refresh

## 🔧 Configuración Adicional

### En `main.dart` se agregó:
- Provider del reporte
- Ruta `/maintenance-report`
- Imports necesarios

### En `maintenance_history_page.dart` se agregó:
- Botón de navegación al reporte en el AppBar

## 📱 Estados de la UI

| Estado | Descripción | Acción del Usuario |
|--------|-------------|-------------------|
| `initial` | Estado inicial | - |
| `loading` | Cargando datos | Esperar |
| `loaded` | Datos cargados correctamente | Ver reporte |
| `error` | Error al cargar | Reintentar |
| `exporting` | Exportando PDF | Esperar |
| `exported` | PDF generado | Abrir PDF |

## 🎨 Diseño Visual

El diseño mantiene la coherencia con el resto de la aplicación:
- Colores: `AppTheme.primaryColor` (#2196F3)
- Tarjetas con bordes redondeados (12px)
- Sombras sutiles
- Iconos descriptivos
- Tipografía consistente

## 📝 Notas Importantes

1. **Autenticación**: El reporte requiere que el usuario esté autenticado (token JWT)
2. **Idioma**: Todas las fechas se formatean en español (es_ES)
3. **Responsive**: La UI se adapta a diferentes tamaños de pantalla
4. **Error Handling**: Todos los errores se capturan y muestran mensajes amigables

## 🐛 Troubleshooting

### "No hay token de autenticación"
- Verificar que el usuario haya iniciado sesión
- Revisar `AuthStorageService`

### "Error al obtener el reporte"
- Verificar que el backend esté corriendo
- Revisar la configuración de `ApiConfig.baseUrl`
- Verificar los endpoints del backend

### El PDF no se abre
- Verificar que la URL retornada por el backend sea válida
- Revisar permisos de la aplicación para abrir URLs externas

## 🔜 Mejoras Futuras

- [ ] Filtro por motocicleta específica
- [ ] Gráficos más avanzados (líneas, tortas)
- [ ] Exportar a otros formatos (CSV, Excel)
- [ ] Compartir reporte por email/WhatsApp
- [ ] Comparación entre períodos
- [ ] Estadísticas predictivas

---

**Última actualización**: 15 de noviembre de 2025
**Desarrollado por**: Equipo Frontend ManteniApp
**Versión**: 1.0.0
