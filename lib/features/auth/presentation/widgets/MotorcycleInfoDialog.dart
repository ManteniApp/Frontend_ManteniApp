import 'package:flutter/material.dart';
import 'package:frontend_manteniapp/features/motorcycles/domain/entities/motorcycle_entity.dart';

class MotorcycleInfoDialog extends StatelessWidget {
  final MotorcycleEntity motorcycle;

  const MotorcycleInfoDialog({super.key, required this.motorcycle});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Información del Vehículo",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1976D2),
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.directions_bike, "Marca", motorcycle.brand),
            _buildInfoRow(Icons.build, "Modelo", motorcycle.model),
            _buildInfoRow(Icons.confirmation_number, "Placa",
                motorcycle.licensePlate ?? "No registrada"),
            _buildInfoRow(Icons.calendar_today, "Año", motorcycle.year.toString()),
            _buildInfoRow(Icons.speed, "Cilindraje", "${motorcycle.displacement} cc"),
            _buildInfoRow(Icons.av_timer, "Kilometraje", "${motorcycle.mileage} km"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Cerrar", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[700], size: 20),
          const SizedBox(width: 10),
          Text(
            "$label:",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}