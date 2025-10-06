import 'package:flutter/material.dart';

class BikeHeader extends StatelessWidget {
  const BikeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 🔹 Botón del perfil (avatar)
        IconButton(
          onPressed: () {},
          icon: const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/images/profile.png'),
          ),
        ),
        const SizedBox(width: 10),

        // 🔹 Textos
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Tus Motos',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            Text(
              'Perfil de Moto',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
              ),
            ),
          ],
        ),

        const Spacer(),

        // 🔹 Botón notificaciones
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_rounded, color: Colors.black54),
        ),
      ],
    );
  }
}
