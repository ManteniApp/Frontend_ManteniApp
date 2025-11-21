import 'package:flutter/material.dart';
import '../../domain/entities/recommendation_entity.dart';

/// Widget para mostrar una tarjeta de recomendación de mantenimiento
class RecommendationCard extends StatelessWidget {
  final MaintenanceRecommendationEntity recommendation;

  const RecommendationCard({Key? key, required this.recommendation})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () => _showDetailDialog(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado con icono y nombre
              Row(
                children: [
                  _buildIcon(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recommendation.componentName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          recommendation.category,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildPriorityBadge(),
                ],
              ),
              const SizedBox(height: 12),

              // Descripción
              Text(
                recommendation.description,
                style: const TextStyle(fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Frecuencias
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (recommendation.frequencyKm != null)
                    _buildFrequencyChip(
                      icon: Icons.speed,
                      label: '${recommendation.frequencyKm} km',
                      color: Colors.blue,
                    ),
                  if (recommendation.frequencyMonths != null)
                    _buildFrequencyChip(
                      icon: Icons.calendar_month,
                      label: '${recommendation.frequencyMonths} meses',
                      color: Colors.orange,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    IconData iconData;
    switch (recommendation.iconName.toLowerCase()) {
      case 'oil_barrel':
      case 'oil':
        iconData = Icons.oil_barrel;
        break;
      case 'brake':
      case 'brakes':
        iconData = Icons.cancel;
        break;
      case 'tire':
      case 'tires':
        iconData = Icons.tire_repair;
        break;
      case 'filter':
        iconData = Icons.filter_alt;
        break;
      case 'battery':
        iconData = Icons.battery_charging_full;
        break;
      case 'chain':
        iconData = Icons.link;
        break;
      default:
        iconData = Icons.build;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2196F3).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(iconData, size: 32, color: const Color(0xFF2196F3)),
    );
  }

  Widget _buildPriorityBadge() {
    Color color;
    String text;

    switch (recommendation.priority.toLowerCase()) {
      case 'alta':
      case 'high':
        color = Colors.red;
        text = 'Alta';
        break;
      case 'media':
      case 'medium':
        color = Colors.orange;
        text = 'Media';
        break;
      case 'baja':
      case 'low':
        color = Colors.green;
        text = 'Baja';
        break;
      default:
        return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildFrequencyChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showDetailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            _buildIcon(),
            const SizedBox(width: 12),
            Expanded(child: Text(recommendation.componentName)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Categoría y prioridad
              Row(
                children: [
                  Chip(
                    label: Text(recommendation.category),
                    backgroundColor: const Color(0xFF2196F3).withOpacity(0.1),
                  ),
                  const SizedBox(width: 8),
                  _buildPriorityBadge(),
                ],
              ),
              const SizedBox(height: 16),

              // Descripción
              const Text(
                'Descripción',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(recommendation.description),
              const SizedBox(height: 16),

              // Frecuencias
              const Text(
                'Frecuencia Recomendada',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (recommendation.frequencyKm != null)
                Row(
                  children: [
                    const Icon(Icons.speed, size: 20, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text('Cada ${recommendation.frequencyKm} km'),
                  ],
                ),
              if (recommendation.frequencyMonths != null)
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      size: 20,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Text('Cada ${recommendation.frequencyMonths} meses'),
                  ],
                ),
              const SizedBox(height: 16),

              // Explicación
              const Text(
                'Explicación',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(recommendation.explanation),
              const SizedBox(height: 16),

              // Señales de advertencia
              if (recommendation.warningSignals != null &&
                  recommendation.warningSignals!.isNotEmpty) ...[
                const Text(
                  'Señales de Advertencia',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...recommendation.warningSignals!.map(
                  (signal) => Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.warning_amber,
                          size: 20,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(signal)),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
