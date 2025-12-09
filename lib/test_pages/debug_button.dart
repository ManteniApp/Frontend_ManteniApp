import 'package:flutter/material.dart';

/// Widget flotante de debug para acceso rápido a herramientas de prueba
class DebugButton extends StatelessWidget {
  const DebugButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 80,
      right: 16,
      child: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.orange,
        onPressed: () {
          _showDebugMenu(context);
        },
        child: const Icon(Icons.bug_report, size: 20),
      ),
    );
  }

  void _showDebugMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '🛠️ Menú de Debug',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.science, color: Colors.blue),
              title: const Text('Test de Endpoints'),
              subtitle: const Text('Probar conexión con backend'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/test-recommendations');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.close, color: Colors.red),
              title: const Text('Cerrar'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
