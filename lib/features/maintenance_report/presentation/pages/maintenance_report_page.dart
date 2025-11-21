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

class MaintenanceReportPage extends StatefulWidget {
  const MaintenanceReportPage({super.key});

  @override
  State<MaintenanceReportPage> createState() => _MaintenanceReportPageState();
}

class _MaintenanceReportPageState extends State<MaintenanceReportPage> {
  @override
  void initState() {
    super.initState();
    // Cargar el reporte al iniciar la página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MaintenanceReportProvider>().loadReport();
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
