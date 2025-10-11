import 'package:flutter/material.dart';

class IndicatorPill extends StatelessWidget {
  final Widget content;
  final String title;
  final bool highlight;

  const IndicatorPill({
    super.key,
    required this.content,
    required this.title,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 120,
          decoration: BoxDecoration(
            color: highlight ? const Color(0xFF007BFF) : Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF007BFF).withOpacity(0.25),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(child: content),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
