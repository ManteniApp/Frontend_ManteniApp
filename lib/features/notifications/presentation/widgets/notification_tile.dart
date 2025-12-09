import 'package:flutter/material.dart';
import 'package:frontend_manteniapp/features/notifications/state/notification_provier.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../data/notification_model.dart';

class NotificationTile extends StatelessWidget {
  final AppNotification notificacion;

  const NotificationTile({required this.notificacion});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: notificacion.leida ? Colors.grey[100] : Colors.blue[50],
      child: ListTile(
        leading: _getNotificationIcon(notificacion.tipo),
        title: Text(
          notificacion.titulo,
          style: TextStyle(
            fontWeight: notificacion.leida ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notificacion.descripcion),
            SizedBox(height: 4),
            Text(
              dateFormat.format(notificacion.fecha),
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (notificacion.leida)
              Icon(Icons.check_circle, color: Colors.green, size: 20)
            else
              Icon(Icons.mark_email_unread, color: Colors.orange, size: 20),
          ],
        ),
        onTap: () {
          Provider.of<NotificationProvider>(context, listen: false)
              .marcarComoLeida(notificacion.id);
        },
        onLongPress: () {
          _showDeleteDialog(context);
        },
      ),
    );
  }

  Widget _getNotificationIcon(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'maintenance':
        return Icon(Icons.build, color: Colors.blue);
      case 'alert':
        return Icon(Icons.warning, color: Colors.orange);
      case 'promo':
        return Icon(Icons.local_offer, color: Colors.green);
      default:
        return Icon(Icons.notifications, color: Colors.grey);
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar notificación'),
        content: Text('¿Estás seguro de eliminar esta notificación?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<NotificationProvider>(context, listen: false)
                  .eliminar(notificacion.id);
              Navigator.pop(context);
            },
            child: Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}