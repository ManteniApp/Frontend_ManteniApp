import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final VoidCallback onTermsPressed;

  const SettingsTile({
    super.key,
    required this.onTermsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título simple, sin contenedor ni sombra
        Padding(
          padding: const EdgeInsets.only(left: 20),   
          child: const Text(
            'Ajustes',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Sólo el botón de Términos y Condiciones con estilo
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 0), // ajusta si quieres separación
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.20),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            leading: const Icon(Icons.article_outlined, color: Color(0xFF007AFF)),
            title: const Text('Términos y condiciones'),
            onTap: onTermsPressed,
            // opcional: shape para que el ripple respete las esquinas
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
