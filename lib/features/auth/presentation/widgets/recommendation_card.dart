import 'package:flutter/material.dart';

enum RecommendationType { alert, recommendation, tip }

class RecommendationCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;
  final RecommendationType type;
  final VoidCallback onTap;

  const RecommendationCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.description,
    required this.type,
    required this.onTap,
  });

  Color getShadowColor() {
    switch (type) {
      case RecommendationType.alert:
        return Colors.orange.withOpacity(0.35);
      case RecommendationType.recommendation:
        return Colors.yellow.shade700.withOpacity(0.35);
      case RecommendationType.tip:
        return Colors.green.withOpacity(0.35);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: getShadowColor(),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    description,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
