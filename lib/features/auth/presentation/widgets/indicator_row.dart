import 'package:flutter/material.dart';
import 'indicator_pill.dart';

class IndicatorsRow extends StatelessWidget {
  const IndicatorsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IndicatorPill(
            title: 'Revisión',
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  '02',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Oct',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF007BFF),
                  ),
                ),
              ],
            ),
          ),
          IndicatorPill(
            highlight: true,
            title: 'Aceite',
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '20',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -10),
                  child: const Text(
                    'Días',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -12),
                  child: const Text(
                    'ó',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -10),
                  child: const Text(
                    '24.000',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -11),
                  child: const Text(
                    'km',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IndicatorPill(
            title: 'Gastos',
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  '56%',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Ahorro',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF007BFF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
