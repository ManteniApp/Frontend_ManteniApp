import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../providers/maintenance_history_provider.dart';
import '../widgets/maintenance_card.dart';
import '../widgets/maintenance_detail_modal.dart';
import '../widgets/filter_button.dart';
import '../widgets/date_filter_modal.dart';
import '../widgets/price_filter_modal.dart';
import '../widgets/motorcycle_filter_modal.dart';
import '../widgets/edit_maintenance_modal.dart';
import '../../domain/entities/maintenance_entity.dart';
import '../../../../core/services/auth_storage_service.dart';
import '../../../motorcycles/presentation/providers/motorcycle_provider.dart';

class MaintenanceHistoryPage extends StatefulWidget {
  const MaintenanceHistoryPage({super.key});

  @override
  State<MaintenanceHistoryPage> createState() => _MaintenanceHistoryPageState();
}

class _MaintenanceHistoryPageState extends State<MaintenanceHistoryPage> {
  bool _isInitialized = false;
  final AuthStorageService _authStorage = AuthStorageService();

  @override
  void initState() {
    super.initState();
    _checkAuthenticationAndInitialize();
  }

  /// Verifica si el usuario está autenticado antes de cargar datos
  Future<void> _checkAuthenticationAndInitialize() async {
    // Verificar si hay un token guardado
    final isAuthenticated = await _authStorage.isAuthenticated();

    if (!mounted) return;

    if (!isAuthenticated) {
      // Si no está autenticado, mostrar mensaje y redirigir al login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes iniciar sesión para ver el historial'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        ),
      );

      // Redirigir al login después de un breve delay
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      });
      return;
    }

    // Si está autenticado, continuar con la inicialización normal
    await _initializeDateFormatting();
  }

  Future<void> _initializeDateFormatting() async {
    // Inicializar formateo de fechas en español
    await initializeDateFormatting('es_ES', null);
    setState(() {
      _isInitialized = true;
    });
    // Cargar datos después de inicializar
    if (mounted) {
      context.read<MaintenanceHistoryProvider>().loadMaintenanceHistory();
    }
  }

  void _showMaintenanceDetail(MaintenanceEntity maintenance) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MaintenanceDetailModal(
        maintenance: maintenance,
        onEdit: () => _showEditMaintenanceDialog(maintenance),
      ),
    );
  }

  void _showEditMaintenanceDialog(MaintenanceEntity maintenance) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => EditMaintenanceModal(
        maintenance: maintenance,
        onSave: (updatedMaintenance) async {
          // ✅ Guardar referencia al ScaffoldMessenger ANTES de cerrar el modal
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          final navigator = Navigator.of(modalContext);

          // Cerrar modal
          navigator.pop();

          try {
            await context.read<MaintenanceHistoryProvider>().updateMaintenance(
              updatedMaintenance,
            );
            // ✅ Usar la referencia guardada
            scaffoldMessenger.showSnackBar(
              const SnackBar(
                content: Text('Mantenimiento actualizado correctamente'),
                backgroundColor: Colors.green,
              ),
            );
          } catch (e) {
            // ✅ Usar la referencia guardada
            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Text('Error al actualizar: ${e.toString()}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      ),
    );
  }

  void _confirmDeleteMaintenance(MaintenanceEntity maintenance) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar Mantenimiento'),
        content: Text(
          '¿Estás seguro de que deseas eliminar este mantenimiento?\n\n'
          '${maintenance.type} - ${maintenance.motorcycleName}\n'
          'Costo: \$${maintenance.cost}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              // ✅ Guardar referencia al ScaffoldMessenger ANTES de cerrar el diálogo
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final navigator = Navigator.of(dialogContext);

              // Cerrar diálogo
              navigator.pop();

              // Validar que el ID no sea nulo
              if (maintenance.id == null) {
                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text('Error: ID de mantenimiento no válido'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              try {
                await context
                    .read<MaintenanceHistoryProvider>()
                    .deleteMaintenance(maintenance.id!);
                // ✅ Usar la referencia guardada
                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text('Mantenimiento eliminado correctamente'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                // ✅ Usar la referencia guardada
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text('Error al eliminar: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _showDateFilter() {
    final provider = Provider.of<MaintenanceHistoryProvider>(
      context,
      listen: false,
    );
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DateFilterModal(
        selectedDate: provider.selectedDate,
        onApply: (date) {
          provider.setDateFilter(date);
        },
      ),
    );
  }

  void _showPriceFilter() {
    final provider = Provider.of<MaintenanceHistoryProvider>(
      context,
      listen: false,
    );
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PriceFilterModal(
        minPrice: provider.minPrice,
        maxPrice: provider.maxPrice,
        onApply: (minPrice, maxPrice) {
          provider.setPriceFilter(minPrice: minPrice, maxPrice: maxPrice);
        },
      ),
    );
  }

  void _showMotorcycleFilter() {
    final provider = Provider.of<MaintenanceHistoryProvider>(
      context,
      listen: false,
    );
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MotorcycleFilterModal(
        selectedMotorcycleId: provider.selectedMotorcycleFilter,
        onApply: (motorcycleId) {
          provider.setMotorcycleFilter(motorcycleId);
        },
      ),
    );
  }

  /// TODO: Implementar navegación a la pantalla de registrar mantenimiento
  /// Esta funcionalidad debe ser implementada por el equipo encargado
  ///
  /// Requisitos:
  /// 1. Crear la ruta en el sistema de navegación (ej: '/register-maintenance')
  /// 2. Después de registrar un mantenimiento exitosamente, recargar el historial:
  ///    context.read<MaintenanceHistoryProvider>().loadMaintenanceHistory();
  /// 3. Opcional: Pasar el ID de la moto seleccionada en el filtro actual para pre-seleccionarla:
  ///    final selectedMotoId = context.read<MaintenanceHistoryProvider>().selectedMotorcycleFilter;
  ///    Navigator.pushNamed(context, '/register-maintenance', arguments: selectedMotoId);
  void _navigateToCreateMaintenance() {
    // TODO: Implementar navegación
    // Navigator.pushNamed(context, '/register-maintenance');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          '⚠️ Funcionalidad pendiente: Navegar a registrar mantenimiento',
        ),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mostrar loading mientras se inicializa el formateo de fechas
    if (!_isInitialized) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Historial',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // Centrar el título
      ),
      body: Column(
        children: [
          // Filtros superiores
          _buildFilters(),

          // Lista de mantenimientos
          Expanded(
            child: Consumer<MaintenanceHistoryProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF2196F3)),
                  );
                }

                if (provider.errorMessage != null) {
                  return _buildErrorState(provider.errorMessage!);
                }

                if (provider.maintenances.isEmpty) {
                  return _buildEmptyState();
                }

                return _buildMaintenanceList(provider.maintenances);
              },
            ),
          ),
        ],
      ),
      // Botón para crear nuevo mantenimiento
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: FloatingActionButton(
          onPressed: _navigateToCreateMaintenance,
          backgroundColor: const Color(0xFF2196F3), // Azul del proyecto
          elevation: 6,
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildFilters() {
    return Consumer<MaintenanceHistoryProvider>(
      builder: (context, maintenanceProvider, child) {
        // Obtener el nombre de la moto seleccionada
        String motorcycleLabel = 'Moto';

        if (maintenanceProvider.selectedMotorcycleFilter != null) {
          final motorcycleProvider = context.read<MotorcycleProvider>();
          final selectedMoto = motorcycleProvider.motorcycles.firstWhere(
            (m) => m.id == maintenanceProvider.selectedMotorcycleFilter,
            orElse: () => motorcycleProvider.motorcycles.first,
          );
          motorcycleLabel = '${selectedMoto.brand} ${selectedMoto.model}';
        }

        // Obtener el label del filtro de fecha
        String dateLabel = 'Fecha';
        if (maintenanceProvider.selectedDate != null) {
          final date = maintenanceProvider.selectedDate!;
          dateLabel = '${date.day}/${date.month}/${date.year}';
        }

        // Obtener el label del filtro de precio
        String priceLabel = 'Precio';
        if (maintenanceProvider.minPrice != null ||
            maintenanceProvider.maxPrice != null) {
          if (maintenanceProvider.minPrice != null &&
              maintenanceProvider.maxPrice != null) {
            priceLabel =
                '\$${maintenanceProvider.minPrice!.toInt()}-\$${maintenanceProvider.maxPrice!.toInt()}';
          } else if (maintenanceProvider.minPrice != null) {
            priceLabel = 'Min \$${maintenanceProvider.minPrice!.toInt()}';
          } else if (maintenanceProvider.maxPrice != null) {
            priceLabel = 'Max \$${maintenanceProvider.maxPrice!.toInt()}';
          }
        }

        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 150),
                    child: FilterButton(
                      label: motorcycleLabel,
                      icon: Icons.motorcycle,
                      onPressed: _showMotorcycleFilter,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 150),
                    child: FilterButton(
                      label: dateLabel,
                      icon: Icons.calendar_today,
                      onPressed: _showDateFilter,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 150),
                    child: FilterButton(
                      label: priceLabel,
                      icon: Icons.attach_money,
                      onPressed: _showPriceFilter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMaintenanceList(List<MaintenanceEntity> maintenances) {
    // Agrupar por fecha (Hoy, Ayer, etc.)
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    final Map<String, List<MaintenanceEntity>> groupedMaintenances = {
      'Hoy': [],
      'Ayer': [],
      'Anteriores': [],
    };

    for (var maintenance in maintenances) {
      final maintenanceDate = DateTime(
        maintenance.date.year,
        maintenance.date.month,
        maintenance.date.day,
      );
      final todayDate = DateTime(today.year, today.month, today.day);
      final yesterdayDate = DateTime(
        yesterday.year,
        yesterday.month,
        yesterday.day,
      );

      if (maintenanceDate == todayDate) {
        groupedMaintenances['Hoy']!.add(maintenance);
      } else if (maintenanceDate == yesterdayDate) {
        groupedMaintenances['Ayer']!.add(maintenance);
      } else {
        groupedMaintenances['Anteriores']!.add(maintenance);
      }
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Hoy
        if (groupedMaintenances['Hoy']!.isNotEmpty) ...[
          _buildSectionHeader('Hoy'),
          const SizedBox(height: 12),
          ...groupedMaintenances['Hoy']!.map(
            (m) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: MaintenanceCard(
                maintenance: m,
                onTap: () => _showMaintenanceDetail(m),
                onDelete: () => _confirmDeleteMaintenance(m),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],

        // Ayer
        if (groupedMaintenances['Ayer']!.isNotEmpty) ...[
          _buildSectionHeader('Ayer'),
          const SizedBox(height: 12),
          ...groupedMaintenances['Ayer']!.map(
            (m) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: MaintenanceCard(
                maintenance: m,
                onTap: () => _showMaintenanceDetail(m),
                onDelete: () => _confirmDeleteMaintenance(m),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],

        // Anteriores
        if (groupedMaintenances['Anteriores']!.isNotEmpty) ...[
          _buildSectionHeader('Anteriores'),
          const SizedBox(height: 12),
          ...groupedMaintenances['Anteriores']!.map(
            (m) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: MaintenanceCard(
                maintenance: m,
                onTap: () => _showMaintenanceDetail(m),
                onDelete: () => _confirmDeleteMaintenance(m),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No hay mantenimientos registrados',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Los mantenimientos aparecerán aquí',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            'Error al cargar',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context
                  .read<MaintenanceHistoryProvider>()
                  .loadMaintenanceHistory();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
