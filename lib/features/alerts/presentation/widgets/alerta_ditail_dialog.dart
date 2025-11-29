import 'package:flutter/material.dart';
import 'package:frontend_manteniapp/features/alerts/data/alert_model.dart';
import 'package:intl/intl.dart';

class AlertDetailDialog extends StatelessWidget {
  final AlertModel alerta;
  final VoidCallback? onMarcarLeida;

  const AlertDetailDialog({
    super.key, 
    required this.alerta,
    this.onMarcarLeida,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            _getEstadoIcon(alerta.estado),
            color: _getEstadoColor(alerta.estado),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Detalle de Alerta',
              style: TextStyle(
                color: _getEstadoColor(alerta.estado),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailItem('Descripción:', alerta.descripcion),
            _buildDetailItem('Detalle:', alerta.detalle),
            _buildDetailItem('Moto:', alerta.motoNombre),
            _buildDetailItem('Tipo:', _getTipoTexto(alerta.tipo)),
            _buildDetailItem('Estado:', _getEstadoTexto(alerta.estado)),
            
            if (alerta.fechaObjetivo != null)
              _buildDetailItem(
                'Fecha objetivo:', 
                DateFormat('dd/MM/yyyy').format(alerta.fechaObjetivo!)
              ),
            
            if (alerta.kmObjetivo != null)
              _buildDetailItem('Kilometraje objetivo:', '${alerta.kmObjetivo} km'),
            
            _buildDetailItem(
              'Creada:', 
              DateFormat('dd/MM/yyyy HH:mm').format(alerta.fechaCreacion)
            ),
            
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getEstadoColor(alerta.estado).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _getMensajeEstado(alerta.estado),
                style: TextStyle(
                  color: _getEstadoColor(alerta.estado),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cerrar'),
        ),
        if (!alerta.leida && onMarcarLeida != null)
          TextButton(
            onPressed: () {
              onMarcarLeida!();
              Navigator.pop(context);
            },
            child: const Text('Marcar como leída'),
          ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Color _getEstadoColor(AlertStatus estado) {
    switch (estado) {
      case AlertStatus.proxima: return Colors.orange;
      case AlertStatus.vencida: return Colors.red;
      case AlertStatus.resuelta: return Colors.green;
      default: return Colors.blue;
    }
  }

  IconData _getEstadoIcon(AlertStatus estado) {
    switch (estado) {
      case AlertStatus.proxima: return Icons.warning_amber;
      case AlertStatus.vencida: return Icons.error;
      case AlertStatus.resuelta: return Icons.check_circle;
      default: return Icons.info;
    }
  }

  String _getEstadoTexto(AlertStatus estado) {
    switch (estado) {
      case AlertStatus.proxima: return 'Próxima';
      case AlertStatus.vencida: return 'Vencida';
      case AlertStatus.resuelta: return 'Resuelta';
      default: return 'Actual';
    }
  }

  String _getTipoTexto(AlertType tipo) {
    switch (tipo) {
      case AlertType.kilometraje: return 'Por kilometraje';
      case AlertType.fecha: return 'Por fecha';
      case AlertType.estado: return 'Por estado';
      // ignore: unreachable_switch_default
      default: return 'Desconocido';
    }
  }

  String _getMensajeEstado(AlertStatus estado) {
    switch (estado) {
      case AlertStatus.proxima: 
        return '⚠️ Este mantenimiento está próximo a vencer';
      case AlertStatus.vencida: 
        return '🚨 Este mantenimiento está vencido';
      case AlertStatus.resuelta: 
        return '✅ Este mantenimiento ha sido resuelto';
      default: 
        return 'ℹ️ Este mantenimiento está en seguimiento';
    }
  }
}