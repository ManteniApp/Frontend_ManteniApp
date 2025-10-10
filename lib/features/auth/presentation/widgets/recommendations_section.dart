import 'package:flutter/material.dart';
import 'recommendation_card.dart';
import '../pages/alerts_placeholder_page.dart';

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
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con título y botón
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Recomendaciones",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Color(0xFF007BFF),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AlertsPlaceholderPage(),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Tarjetas (temporalmente hardcodeadas)
          RecommendationCard(
            emoji: "⚠️",
            title: "Cambio de aceite próximo",
            description:
                "Faltan menos de 300 km para el próximo mantenimiento.",
            type: RecommendationType.alert,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AlertsPlaceholderPage(
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AlertsPlaceholderPage(
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
