import 'package:flutter/material.dart';

class BikeMainInfo extends StatelessWidget {
  const BikeMainInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/bike2.png',
          height: 180,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Royal Enfield GRR 450',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1976D2),
              ),
            ),
            const SizedBox(width: 6),
            IconButton(
              icon: const Icon(
                Icons.info_outline,
                size: 20,
                color: Colors.grey,
              ),
              onPressed: () {
                // acción a definir más adelante
              },
            ),
          ],
        ),

        const Text(
          '23.120 Km',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}
