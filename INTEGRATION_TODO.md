# Integración de Componentes Compartidos

## 📋 Componentes pendientes de integración

### 1. Header Compartido
**Estado:** 🔄 Pendiente  
**Ubicación futura:** `lib/shared/widgets/app_header.dart`  
**Descripción:** Header diseñado en otra feature que se usará en todas las pantallas.

**Pasos para integrar:**
1. Hacer merge/cherry-pick del header desde la otra rama
2. Importar el componente: `import '../../shared/widgets/app_header.dart';`
3. Reemplazar `_buildHeader()` por `AppHeader(title: 'Mis Motocicletas')`

### 2. Barra de Navegación Flotante  
**Estado:** 🔄 Pendiente  
**Ubicación futura:** `lib/shared/widgets/floating_navigation_bar.dart`  
**Descripción:** Barra de navegación flotante diseñada en otra feature.

**Pasos para integrar:**
1. Hacer merge/cherry-pick de la barra de navegación desde la otra rama
2. Importar el componente: `import '../../shared/widgets/floating_navigation_bar.dart';`
3. Descomentar el método `_buildFloatingNavigationBar()` en `list_motorcycle_page.dart`
4. Descomentar la llamada `_buildFloatingNavigationBar()` en el Stack del build()
5. Configurar los parámetros necesarios (currentIndex, onTap, items)

## ⚠️ Consideraciones importantes

### Para el botón de agregar motocicleta:
- Actualmente está posicionado en `bottom: 32, right: 32`
- **Cuando se agregue la barra de navegación flotante**, ajustar la posición:
  ```dart
  Positioned(
    bottom: 100, // Aumentar para que no se superponga con la barra
    right: 32,
    child: FloatingActionButton(...)
  )
  ```

### Estructura actual preparada:
```dart
body: Stack(
  children: [
    SafeArea(child: /* contenido principal */),
    // _buildFloatingNavigationBar(), // ← Listo para descomentar
  ],
)
```

## 🔧 Archivos modificados en esta feature:
- `lib/features/list_motorcicle/presentation/pages/list_motorcycle_page.dart`
- `lib/features/list_motorcicle/presentation/widgets/motorcycle_card.dart`
- `pubspec.yaml`

## 📝 TODOs documentados en código:
- [ ] Reemplazar header temporal por componente compartido
- [ ] Integrar barra de navegación flotante
- [ ] Ajustar posición del FAB cuando se agregue la barra de navegación
- [ ] Cambiar imágenes temporales por URLs del backend