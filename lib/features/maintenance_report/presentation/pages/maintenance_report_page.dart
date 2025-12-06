import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/maintenance_report_provider.dart';
import '../widgets/metric_card.dart';
import '../widgets/frequent_services_card.dart';
import '../widgets/date_range_filter_modal.dart';
import '../widgets/report_states.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../motorcycles/presentation/providers/motorcycle_provider.dart';

class MaintenanceReportPage extends StatefulWidget {
  final String? initialMotorcycleId;

  const MaintenanceReportPage({super.key, this.initialMotorcycleId});

  @override
  State<MaintenanceReportPage> createState() => _MaintenanceReportPageState();
}

class _MaintenanceReportPageState extends State<MaintenanceReportPage> {
  @override
  void initState() {
    super.initState();
    print('🎬 [MaintenanceReportPage] initState ejecutado');
    // Cargar motos y configurar reporte inicial
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print('🎬 [MaintenanceReportPage] addPostFrameCallback ejecutándose');

      final motorcycleProvider = context.read<MotorcycleProvider>();
      final reportProvider = context.read<MaintenanceReportProvider>();

      // Primero cargar las motocicletas
      await motorcycleProvider.loadMotorcycles();

      // Determinar qué moto seleccionar
      String? motorcycleToSelect;

      if (widget.initialMotorcycleId != null) {
        // Si se pasó un ID inicial, verificar que exista en la lista
        final exists = motorcycleProvider.motorcycles.any(
          (m) => m.id == widget.initialMotorcycleId,
        );
        if (exists) {
          motorcycleToSelect = widget.initialMotorcycleId;
          print(
            '🎬 [MaintenanceReportPage] Usando moto del filtro: $motorcycleToSelect',
          );
        }
      }

      // Si no hay ID inicial o no existe, usar la primera disponible
      if (motorcycleToSelect == null &&
          motorcycleProvider.motorcycles.isNotEmpty) {
        motorcycleToSelect = motorcycleProvider.motorcycles.first.id;
        print(
          '🎬 [MaintenanceReportPage] Seleccionando primera moto: $motorcycleToSelect',
        );
      }

      // Seleccionar la moto y cargar el reporte
      if (motorcycleToSelect != null) {
        await reportProvider.setMotorcycle(motorcycleToSelect);
      } else {
        print('⚠️ [MaintenanceReportPage] No hay motocicletas disponibles');
      }
    });
  }

  void _showDateFilter() {
    final provider = context.read<MaintenanceReportProvider>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DateRangeFilterModal(
        initialStartDate: provider.startDate,
        initialEndDate: provider.endDate,
        onApply: (startDate, endDate) {
          provider.setDateRange(startDate, endDate);
        },
      ),
    );
  }

  void _showMotorcycleSelector() {
    final reportProvider = context.read<MaintenanceReportProvider>();
    final motorcycleProvider = context.read<MotorcycleProvider>();

    // Validar si hay motos
    if (motorcycleProvider.motorcycles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No tienes motocicletas registradas'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Título
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Filtrar por motocicleta',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(height: 1),
              // Lista de opciones
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    // Lista de motos
                    ...motorcycleProvider.motorcycles.map((motorcycle) {
                      final isSelected =
                          reportProvider.selectedMotorcycleId == motorcycle.id;
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: motorcycle.imageUrl.isNotEmpty
                              ? NetworkImage(motorcycle.imageUrl)
                              : const AssetImage(
                                      'assets/images/default_bike.png',
                                    )
                                    as ImageProvider,
                        ),
                        title: Text(
                          '${motorcycle.brand} ${motorcycle.model}',
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text(
                          motorcycle.licensePlate ?? '${motorcycle.year}',
                        ),
                        trailing: isSelected
                            ? const Icon(
                                Icons.check_circle,
                                color: AppTheme.primaryColor,
                              )
                            : null,
                        onTap: () {
                          reportProvider.setMotorcycle(motorcycle.id);
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _exportToPdf() async {
    final provider = context.read<MaintenanceReportProvider>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    await provider.exportToPdf();

    if (!mounted) return;

    if (provider.status == ReportStatus.exported && provider.pdfUrl != null) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: const Text('Reporte exportado correctamente'),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'Abrir',
            textColor: Colors.white,
            onPressed: () async {
              final url = Uri.parse(provider.pdfUrl!);
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              }
            },
          ),
        ),
      );
    } else if (provider.status == ReportStatus.error) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(
            provider.errorMessage ?? 'Error al exportar el reporte',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporte de Mantenimientos'),
        actions: [
          Consumer<MaintenanceReportProvider>(
            builder: (context, provider, _) {
              if (provider.hasData) {
                return Row(
                  children: [
                    // Botón de filtro
                    IconButton(
                      icon: Icon(
                        provider.startDate != null || provider.endDate != null
                            ? Icons.filter_alt
                            : Icons.filter_alt_outlined,
                      ),
                      onPressed: _showDateFilter,
                      tooltip: 'Filtrar por fecha',
                    ),
                    // Botón de exportar
                    if (!provider.isExporting)
                      IconButton(
                        icon: const Icon(Icons.download),
                        onPressed: _exportToPdf,
                        tooltip: 'Exportar a PDF',
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<MaintenanceReportProvider>(
        builder: (context, provider, _) {
          // Estado de carga
          if (provider.isLoading) {
            return const LoadingReportState();
          }

          // Estado de error
          if (provider.status == ReportStatus.error) {
            return ErrorReportState(
              message: provider.errorMessage ?? 'Error desconocido',
              onRetry: () => provider.loadReport(),
            );
          }

          // Estado sin datos
          if (!provider.hasData) {
            return const EmptyReportState();
          }

          final report = provider.report!;
          final dateFormat = DateFormat('dd/MM/yyyy', 'es_ES');

          return RefreshIndicator(
            onRefresh: () => provider.loadReport(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Selector de motocicleta
                  Consumer<MotorcycleProvider>(
                    builder: (context, motorcycleProvider, _) {
                      final selectedMoto = provider.selectedMotorcycleId != null
                          ? motorcycleProvider.motorcycles.firstWhere(
                              (m) => m.id == provider.selectedMotorcycleId,
                              orElse: () =>
                                  motorcycleProvider.motorcycles.first,
                            )
                          : null;

                      return Card(
                        elevation: 0,
                        color: AppTheme.primaryColor.withOpacity(0.05),
                        child: InkWell(
                          onTap: _showMotorcycleSelector,
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Icon(
                                  selectedMoto != null
                                      ? Icons.two_wheeler
                                      : Icons.motorcycle,
                                  color: AppTheme.primaryColor,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        selectedMoto != null
                                            ? '${selectedMoto.brand} ${selectedMoto.model}'
                                            : 'Seleccionar motocicleta',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.textPrimaryColor,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        selectedMoto != null
                                            ? 'Reporte de esta moto'
                                            : 'Toca para elegir',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: AppTheme.primaryColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Información de filtros activos
                  if (provider.startDate != null || provider.endDate != null)
                    Card(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              size: 20,
                              color: AppTheme.primaryColor,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Filtrado: ${provider.startDate != null ? dateFormat.format(provider.startDate!) : "Inicio"} - ${provider.endDate != null ? dateFormat.format(provider.endDate!) : "Hoy"}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => provider.clearFilters(),
                              child: const Text(
                                'Limpiar',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (provider.startDate != null || provider.endDate != null)
                    const SizedBox(height: 16),

                  // Métricas principales
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    children: [
                      MetricCard(
                        title: 'Total Mantenimientos',
                        value: '${report.totalMaintenances}',
                        icon: Icons.build,
                        iconColor: AppTheme.primaryColor,
                      ),
                      MetricCard(
                        title: 'Costo Total',
                        value: '\$${report.totalCost.toStringAsFixed(0)}',
                        icon: Icons.attach_money,
                        iconColor: Colors.green,
                      ),
                      MetricCard(
                        title: 'Costo Promedio',
                        value: '\$${report.averageCost.toStringAsFixed(0)}',
                        icon: Icons.trending_up,
                        iconColor: Colors.orange,
                      ),
                      MetricCard(
                        title: 'Último Mantenimiento',
                        value: report.lastMaintenanceDate != null
                            ? dateFormat.format(report.lastMaintenanceDate!)
                            : 'N/A',
                        icon: Icons.calendar_today,
                        iconColor: Colors.blue,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Servicios más frecuentes
                  FrequentServicesCard(services: report.mostFrequentServices),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
