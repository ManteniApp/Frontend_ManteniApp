import 'package:flutter/material.dart';

class AlertsPlaceholderPage extends StatelessWidget {
  final String? selectedAlert;
  const AlertsPlaceholderPage({super.key, this.selectedAlert});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alertas"),
        backgroundColor: const Color(0xFF007BFF),
      ),
      body: Center(
        child: Text(
          selectedAlert != null
              ? "Mostrando alerta: $selectedAlert"
              : "Página de alertas (aún en desarrollo)",
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
