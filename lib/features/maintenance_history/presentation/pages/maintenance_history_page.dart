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
import '../../domain/entities/maintenance_entity.dart';

class MaintenanceHistoryPage extends StatefulWidget {
  const MaintenanceHistoryPage({super.key});

  @override
  State<MaintenanceHistoryPage> createState() => _MaintenanceHistoryPageState();
}

class _MaintenanceHistoryPageState extends State<MaintenanceHistoryPage> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeDateFormatting();
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
      builder: (context) => MaintenanceDetailModal(maintenance: maintenance),
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
        startDate: provider.startDate,
        endDate: provider.endDate,
        onApply: (startDate, endDate) {
          provider.setDateFilter(startDate: startDate, endDate: endDate);
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
      backgroundColor: const Color(0xFFF5F5F5),
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
    );
  }

  Widget _buildFilters() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          FilterButton(
            label: 'Moto',
            icon: Icons.motorcycle,
            onPressed: _showMotorcycleFilter,
          ),
          const SizedBox(width: 8),
          FilterButton(
            label: 'Fecha',
            icon: Icons.calendar_today,
            onPressed: _showDateFilter,
          ),
          const SizedBox(width: 8),
          FilterButton(
            label: 'Precio',
            icon: Icons.attach_money,
            onPressed: _showPriceFilter,
          ),
        ],
      ),
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
          ...groupedMaintenances['Hoy']!
              .map(
                (m) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: MaintenanceCard(
                    maintenance: m,
                    onTap: () => _showMaintenanceDetail(m),
                  ),
                ),
              )
              .toList(),
          const SizedBox(height: 24),
        ],

        // Ayer
        if (groupedMaintenances['Ayer']!.isNotEmpty) ...[
          _buildSectionHeader('Ayer'),
          const SizedBox(height: 12),
          ...groupedMaintenances['Ayer']!
              .map(
                (m) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: MaintenanceCard(
                    maintenance: m,
                    onTap: () => _showMaintenanceDetail(m),
                  ),
                ),
              )
              .toList(),
          const SizedBox(height: 24),
        ],

        // Anteriores
        if (groupedMaintenances['Anteriores']!.isNotEmpty) ...[
          _buildSectionHeader('Anteriores'),
          const SizedBox(height: 12),
          ...groupedMaintenances['Anteriores']!
              .map(
                (m) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: MaintenanceCard(
                    maintenance: m,
                    onTap: () => _showMaintenanceDetail(m),
                  ),
                ),
              )
              .toList(),
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
