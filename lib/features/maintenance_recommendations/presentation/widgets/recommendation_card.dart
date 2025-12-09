import 'package:flutter/material.dart';
import '../../domain/entities/recommendation_entity.dart';

/// Widget para mostrar una tarjeta de recomendación de mantenimiento
class RecommendationCard extends StatelessWidget {
  final MaintenanceRecommendationEntity recommendation;

  const RecommendationCard({super.key, required this.recommendation});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2196F3).withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showDetailDialog(context),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Encabezado con icono, nombre y prioridad
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
                              color: Color(0xFF212121),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2196F3).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              recommendation.category,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF2196F3),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildPriorityBadge(),
                  ],
                ),
                const SizedBox(height: 16),

                // Descripción con estilo mejorado
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    recommendation.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 16),

                // Frecuencias con diseño mejorado
                Row(
                  children: [
                    if (recommendation.frequencyKm != null)
                      Expanded(
                        child: _buildFrequencyChip(
                          icon: Icons.speed,
                          label: '${recommendation.frequencyKm} km',
                          color: const Color(0xFF2196F3),
                        ),
                      ),
                    if (recommendation.frequencyKm != null &&
                        recommendation.frequencyMonths != null)
                      const SizedBox(width: 8),
                    if (recommendation.frequencyMonths != null)
                      Expanded(
                        child: _buildFrequencyChip(
                          icon: Icons.calendar_month,
                          label: '${recommendation.frequencyMonths} meses',
                          color: const Color(0xFFFF9800),
                        ),
                      ),
                  ],
                ),

                // Indicador de "Ver más"
                const SizedBox(height: 12),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2196F3).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Ver detalles',
                          style: TextStyle(
                            fontSize: 12,
                            color: const Color(0xFF2196F3),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: const Color(0xFF2196F3),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
    IconData icon;

    switch (recommendation.priority.toLowerCase()) {
      case 'alta':
      case 'high':
        color = const Color(0xFFE53935);
        text = 'Alta';
        icon = Icons.priority_high;
        break;
      case 'media':
      case 'medium':
        color = const Color(0xFFFF9800);
        text = 'Media';
        icon = Icons.warning_amber;
        break;
      case 'baja':
      case 'low':
        color = const Color(0xFF4CAF50);
        text = 'Baja';
        icon = Icons.info_outline;
        break;
      default:
        return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrequencyChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: color,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
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
