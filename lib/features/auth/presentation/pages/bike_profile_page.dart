import 'package:flutter/material.dart';
import 'package:frontend_manteniapp/features/motorcycles/domain/entities/motorcycle_entity.dart';
import 'package:frontend_manteniapp/features/auth/presentation/widgets/recommendations_section.dart';
import 'package:frontend_manteniapp/features/auth/presentation/widgets/MotorcycleInfoDialog.dart';
import '../widgets/indicator_row.dart';

class BikeProfilePage extends StatelessWidget {
  final MotorcycleEntity motorcycle;

  const BikeProfilePage({super.key, required this.motorcycle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //////////////////////////////////////////////////////////////////// Imagen + botón back
              Stack(
                children: [
                  Center(child: _buildMotorcycleImage(motorcycle)),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF007BFF),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),

              //////////////////////////////////////////////////////////////////// Nombre + info
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        motorcycle.fullName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF1976D2),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) =>
                                MotorcycleInfoDialog(motorcycle: motorcycle),
                          );
                        },
                        icon: const Icon(
                          Icons.info_outline,
                          size: 20,
                          color: Color(0xFF1976D2),
                        ),
                      ),
                    ],
                  ),
                  Transform.translate(
                    offset: const Offset(0, -10),
                    child: Text(
                      "${motorcycle.mileage} Km", // 👈 dinámico
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),
              IndicatorsRow(),
              Transform.translate(
                offset: const Offset(0, -40),
                child: const RecommendationsSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Método que decide qué mostrar según si hay imagen o no
  Widget _buildMotorcycleImage(MotorcycleEntity moto) {
    if (moto.imageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          moto.imageUrl,
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _fallbackImage();
          },
        ),
      );
    } else {
      return _fallbackImage();
    }
  }

  /// 🔹 Imagen de fallback con ícono y texto
  Widget _fallbackImage() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        //color: const Color.fromARGB(64, 144, 202, 249),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.motorcycle, size: 80, color: Colors.blue),
          SizedBox(height: 8),
          Text(
            "Imagen no disponible",
            style: TextStyle(color: Colors.blue, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
