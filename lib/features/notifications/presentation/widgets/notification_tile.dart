import 'package:flutter/material.dart';
import '../../data/notification_model.dart';
import 'package:provider/provider.dart';
import '../../state/notification_provier.dart';


class NotificationTile extends StatelessWidget {
  final AppNotification notificacion;

  const NotificationTile({required this.notificacion});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(notificacion.titulo),
      subtitle: Text(
        "${notificacion.descripcion}\n${notificacion.fecha}",
        style: TextStyle(fontSize: 12),
      ),
      isThreeLine: true,
      trailing: notificacion.leida
          ? Icon(Icons.check_circle, color: Colors.green)
          : Icon(Icons.mark_email_unread, color: Colors.orange),
      onTap: () {
        Provider.of<NotificationProvider>(context, listen: false)
            .marcarComoLeida(notificacion.id);
      },
      onLongPress: () {
        Provider.of<NotificationProvider>(context, listen: false)
            .eliminar(notificacion.id);
      },
    );
  }
}
