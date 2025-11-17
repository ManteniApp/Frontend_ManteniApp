import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/notification_tile.dart';
import '../../state/notification_provier.dart';


class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notifs = context.watch<NotificationProvider>().notificaciones;

    return Scaffold(
      appBar: AppBar(title: Text("Notificaciones")),
      body: ListView.builder(
        itemCount: notifs.length,
        itemBuilder: (_, i) {
          return NotificationTile(notificacion: notifs[i]);
        },
      ),
    );
  }
}
