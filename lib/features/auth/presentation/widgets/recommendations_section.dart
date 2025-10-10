import 'package:flutter/material.dart';
import 'package:frontend_manteniapp/core/layout/main_layout.dart';
import 'recommendation_card.dart';

class RecommendationsSection extends StatelessWidget {
  const RecommendationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF007BFF).withOpacity(0.25),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          ///////////////////////////////////////////////////// Header con título y botón
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Recomendaciones",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Color(0xFF007BFF),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MainLayout(initialIndex: 3),
                    ),
                  );
                },
              ),
            ],
          ),

          //const SizedBox(height: 14),

          // Tarjetas (temporalmente hardcodeadas)
          RecommendationCard(
            emoji: "⚠️",
            title: "Cambio de aceite próximo",
            description:
                "Faltan menos de 300 km para el próximo mantenimiento.",
            type: RecommendationType.alert,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => MainLayout(
                    initialIndex: 3,
                    selectedAlert: "Cambio de aceite",
                  ),
                ),
              );
            },
          ),
          RecommendationCard(
            emoji: "💡",
            title: "Presión de llantas",
            description:
                "Revisa la presión semanalmente para evitar desgaste irregular.",
            type: RecommendationType.tip,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => MainLayout(
                    initialIndex: 3,
                    selectedAlert: "Presión de llantas",
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
