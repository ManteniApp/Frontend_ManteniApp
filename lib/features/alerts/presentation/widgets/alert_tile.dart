import 'package:flutter/material.dart';
import '../../data/alert_model.dart';
import 'package:intl/intl.dart'; 

class AlertTile extends StatelessWidget {
  final AlertModel alerta;
  final VoidCallback? onMarcarLeida;
  final VoidCallback? onResolver;
  final VoidCallback? onVerDetalle;

  const AlertTile({
    required this.alerta,
    this.onMarcarLeida,
    this.onResolver,
    this.onVerDetalle,
  });

  Color getEstadoColor(AlertStatus estado) {
    switch (estado) {
      case AlertStatus.proxima:
        return Colors.orange;
      case AlertStatus.vencida:
        return Colors.red;
      case AlertStatus.resuelta:
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  IconData getEstadoIcon(AlertStatus estado) {
    switch (estado) {
      case AlertStatus.proxima:
        return Icons.warning_amber;
      case AlertStatus.vencida:
        return Icons.error;
      case AlertStatus.resuelta:
        return Icons.check_circle;
      default:
        return Icons.info;
    }
  }

  String getEstadoTexto(AlertStatus estado) {
    switch (estado) {
      case AlertStatus.proxima:
        return 'PRÓXIMA';
      case AlertStatus.vencida:
        return 'VENCIDA';
      case AlertStatus.resuelta:
        return 'RESUELTA';
      default:
        return 'ACTUAL';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: onVerDetalle,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con estado y botones
              Row(
                children: [
                  Icon(
                    getEstadoIcon(alerta.estado),
                    color: getEstadoColor(alerta.estado),
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      alerta.descripcion,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: getEstadoColor(alerta.estado),
                      ),
                    ),
                  ),
                  if (!alerta.leida)
                    IconButton(
                      icon: const Icon(Icons.mark_email_read, size: 20),
                      color: Colors.blue,
                      onPressed: onMarcarLeida,
                      tooltip: 'Marcar como leída',
                    ),
                  if (alerta.estado != AlertStatus.resuelta)
                    IconButton(
                      icon: const Icon(Icons.check_circle, size: 20),
                      color: Colors.green,
                      onPressed: onResolver,
                      tooltip: 'Marcar como resuelta',
                    ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Información de la moto
              Text(
                'Moto: ${alerta.motoNombre}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              const SizedBox(height: 4),
              
              // Detalles específicos
              Text(
                alerta.detalle,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              
              const SizedBox(height: 8),
              
              // Información de fechas/kilometraje
              Row(
                children: [
                  if (alerta.fechaObjetivo != null)
                    Expanded(
                      child: Text(
                        'Vence: ${DateFormat('dd/MM/yyyy').format(alerta.fechaObjetivo!)}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  if (alerta.kmObjetivo != null)
                    Expanded(
                      child: Text(
                        'Km: ${alerta.kmObjetivo}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Badge de estado
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: getEstadoColor(alerta.estado).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      getEstadoTexto(alerta.estado),
                      style: TextStyle(
                        color: getEstadoColor(alerta.estado),
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  if (!alerta.leida) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'NUEVO',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 8,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}