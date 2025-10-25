import 'package:flutter/material.dart';
import 'package:frontend_manteniapp/features/maintenance_history/domain/entities/maintenance_entity.dart';

class MaintenanceDetailModal extends StatelessWidget {
  final MaintenanceEntity maintenance;

  const MaintenanceDetailModal({super.key, required this.maintenance});

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'general':
        return const Color(0xFF2196F3); // Blue
      case 'eléctrico':
      case 'electrico':
        return const Color(0xFFFFB300); // Yellow
      case 'mecánico':
      case 'mecanico':
        return const Color(0xFF43A047); // Green
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con línea de color
          Row(
            children: [
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: _getTypeColor(maintenance.type),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      maintenance.type,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      maintenance.motorcycleName,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                color: Colors.grey[600],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Fecha
          _buildDetailRow(
            icon: Icons.calendar_today,
            label: 'Fecha',
            value: _formatDate(maintenance.date),
          ),
          const SizedBox(height: 16),

          // Costo
          _buildDetailRow(
            icon: Icons.attach_money,
            label: 'Costo',
            value: '\$${maintenance.cost.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 16),

          // Descripción
          if (maintenance.description != null &&
              maintenance.description!.isNotEmpty)
            _buildDetailSection(
              icon: Icons.description,
              label: 'Descripción',
              content: maintenance.description!,
            ),

          const SizedBox(height: 16),

          // Notas
          if (maintenance.notes != null && maintenance.notes!.isNotEmpty)
            _buildDetailSection(
              icon: Icons.notes,
              label: 'Notas',
              content: maintenance.notes!,
            ),

          const SizedBox(height: 24),

          // Botón cerrar
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Cerrar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildDetailSection({
    required IconData icon,
    required String label,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(content, style: const TextStyle(fontSize: 15)),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    return '${date.day} de ${months[date.month - 1]} de ${date.year}';
  }

  static void show(BuildContext context, MaintenanceEntity maintenance) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MaintenanceDetailModal(maintenance: maintenance),
    );
  }
}
