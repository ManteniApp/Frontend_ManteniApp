import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isActive;

  const FilterButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 18,
        color: isActive ? const Color(0xFF2196F3) : Colors.grey[700],
      ),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          color: isActive ? const Color(0xFF2196F3) : Colors.grey[700],
          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 8),
        side: BorderSide(
          color: isActive ? const Color(0xFF2196F3) : Colors.grey[300]!,
          width: isActive ? 2 : 1,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: isActive
            ? const Color(0xFF2196F3).withOpacity(0.1)
            : Colors.white,
      ),
    );
  }
}
