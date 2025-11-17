import 'package:flutter/material.dart';
import '../../data/alert_model.dart';
import 'package:intl/intl.dart'; 

class AlertTile extends StatelessWidget {
  final AlertModel alerta;

  const AlertTile({required this.alerta});

  Color getEstadoColor(AlertStatus estado) {
    switch (estado) {
      case AlertStatus.proxima:
        return Colors.orange;
      case AlertStatus.vencida:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData getEstadoIcon(AlertStatus estado) {
    switch (estado) {
      case AlertStatus.proxima:
        return Icons.warning_amber;
      case AlertStatus.vencida:
        return Icons.error;
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
      default:
        return 'ACTUAL';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Icon(
          getEstadoIcon(alerta.estado),
          color: getEstadoColor(alerta.estado),
          size: 28,
        ),
        title: Text(
          alerta.descripcion,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: getEstadoColor(alerta.estado),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Tipo: ${alerta.tipo.toString().split('.').last.toUpperCase()}',
              style: const TextStyle(fontSize: 12),
            ),
            if (alerta.fechaObjetivo != null)
              Text(
                'Fecha: ${DateFormat('dd/MM/yyyy').format(alerta.fechaObjetivo!)}',
                style: const TextStyle(fontSize: 12),
              ),
          ],
        ),
        trailing: Container(
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
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}