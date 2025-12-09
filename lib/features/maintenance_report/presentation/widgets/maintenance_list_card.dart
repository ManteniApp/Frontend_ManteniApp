import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/maintenance_report_entity.dart';

/// Widget para mostrar la lista detallada de mantenimientos
class MaintenanceListCard extends StatelessWidget {
  final List<MaintenanceDetail> maintenances;

  const MaintenanceListCard({super.key, required this.maintenances});

  @override
  Widget build(BuildContext context) {
    if (maintenances.isEmpty) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'No hay mantenimientos registrados',
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 14,
              ),
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.history,
                    color: AppTheme.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Historial de mantenimientos',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...maintenances
                .map(
                  (maintenance) => _MaintenanceItem(maintenance: maintenance),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}

class _MaintenanceItem extends StatelessWidget {
  final MaintenanceDetail maintenance;

  const _MaintenanceItem({required this.maintenance});

  IconData _getIconForType(String tipo) {
    final tipoLower = tipo.toLowerCase();
    if (tipoLower.contains('aceite')) return Icons.oil_barrel;
    if (tipoLower.contains('afinamiento') || tipoLower.contains('afinación')) {
      return Icons.tune;
    }
    if (tipoLower.contains('freno')) return Icons.disc_full;
    if (tipoLower.contains('llanta') || tipoLower.contains('neumático')) {
      return Icons.album;
    }
    if (tipoLower.contains('batería')) return Icons.battery_charging_full;
    if (tipoLower.contains('filtro')) return Icons.filter_alt;
    if (tipoLower.contains('cadena')) return Icons.link;
    return Icons.build;
  }

  Color _getColorForType(String tipo) {
    final tipoLower = tipo.toLowerCase();
    if (tipoLower.contains('aceite')) return Colors.orange;
    if (tipoLower.contains('afinamiento') || tipoLower.contains('afinación')) {
      return Colors.blue;
    }
    if (tipoLower.contains('freno')) return Colors.red;
    if (tipoLower.contains('llanta') || tipoLower.contains('neumático')) {
      return Colors.purple;
    }
    if (tipoLower.contains('batería')) return Colors.green;
    if (tipoLower.contains('filtro')) return Colors.teal;
    if (tipoLower.contains('cadena')) return Colors.brown;
    return AppTheme.primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy', 'es_ES');
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 0,
    );
    final color = _getColorForType(maintenance.tipo);
    final icon = _getIconForType(maintenance.tipo);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Opcional: Mostrar detalles completos en un diálogo
          _showMaintenanceDetails(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icono del tipo de mantenimiento
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              // Información del mantenimiento
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            maintenance.tipo,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimaryColor,
                            ),
                          ),
                        ),
                        Text(
                          currencyFormat.format(maintenance.costo),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          dateFormat.format(maintenance.fecha),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (maintenance.kilometraje != null) ...[
                          const SizedBox(width: 12),
                          Icon(Icons.speed, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${NumberFormat('#,###').format(maintenance.kilometraje)} km',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (maintenance.descripcion != null &&
                        maintenance.descripcion!.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        maintenance.descripcion!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMaintenanceDetails(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy', 'es_ES');
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 0,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              _getIconForType(maintenance.tipo),
              color: _getColorForType(maintenance.tipo),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                maintenance.tipo,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailRow(
              icon: Icons.calendar_today,
              label: 'Fecha',
              value: dateFormat.format(maintenance.fecha),
            ),
            const SizedBox(height: 12),
            _DetailRow(
              icon: Icons.attach_money,
              label: 'Costo',
              value: currencyFormat.format(maintenance.costo),
            ),
            if (maintenance.kilometraje != null) ...[
              const SizedBox(height: 12),
              _DetailRow(
                icon: Icons.speed,
                label: 'Kilometraje',
                value:
                    '${NumberFormat('#,###').format(maintenance.kilometraje)} km',
              ),
            ],
            if (maintenance.descripcion != null &&
                maintenance.descripcion!.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Descripción',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                maintenance.descripcion!,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }
}
