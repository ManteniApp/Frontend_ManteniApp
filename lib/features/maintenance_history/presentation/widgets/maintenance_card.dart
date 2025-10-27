import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/maintenance_entity.dart';

class MaintenanceCard extends StatelessWidget {
  final MaintenanceEntity maintenance;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const MaintenanceCard({
    super.key,
    required this.maintenance,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$',
      decimalDigits: 0,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Indicador de tipo (barra vertical)
            Container(
              width: 4,
              height: 60,
              decoration: BoxDecoration(
                color: _getTypeColor(maintenance.type),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),

            // Información del mantenimiento
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Primera fila: Tipo de mantenimiento y Nombre de moto
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Mantenimiento',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        maintenance.motorcycleName,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Segunda fila: Tipo y Precio
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        maintenance.type,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        formatter.format(maintenance.cost),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Tercera fila: Fecha y botón eliminar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDate(maintenance.date),
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                      IconButton(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete_outline),
                        color: Colors.red[400],
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        tooltip: 'Eliminar',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Formateo manual de fecha en español sin usar DateFormat con locale
    final months = [
      'ene',
      'feb',
      'mar',
      'abr',
      'may',
      'jun',
      'jul',
      'ago',
      'sep',
      'oct',
      'nov',
      'dic',
    ];

    final day = date.day.toString().padLeft(2, '0');
    final month = months[date.month - 1];
    final year = date.year;

    return '$day $month $year';
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'general':
      case 'mantenimiento general':
        return const Color(0xFF2196F3); // Azul
      case 'eléctrico':
      case 'mantenimiento eléctrico':
      case 'electrico':
      case 'mantenimiento electrico':
        return const Color(0xFFFFB300); // Amarillo
      case 'mecánico':
      case 'mantenimiento mecánico':
      case 'mecanico':
      case 'mantenimiento mecanico':
        return const Color(0xFF43A047); // Verde
      default:
        return const Color(0xFF757575); // Gris
    }
  }
}
