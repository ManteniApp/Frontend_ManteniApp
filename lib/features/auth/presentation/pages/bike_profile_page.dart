import 'package:flutter/material.dart';
import 'package:frontend_manteniapp/features/auth/presentation/widgets/recommendations_section.dart';
import 'package:frontend_manteniapp/features/list_motorcicle/domain/entities/motorcycle_entity.dart';
import '../widgets/indicator_row.dart';

class BikeProfilePage extends StatelessWidget {
  const BikeProfilePage({super.key, required MotorcycleEntity motorcycle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ////////////////////////////////////////////////////////////////////  Imagen + info
              Center(
                child: Column(
                  children: [
                    Image.asset('assets/images/bike2.png', height: 180),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 20),
                        const Text(
                          'Royal Enfield GRR 450',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF1976D2),
                          ),
                        ),

                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.info_outline,
                            size: 20,
                            color: Color(0xFF1976D2),
                          ),
                        ),
                      ],
                    ),
                    Transform.translate(
                      offset: const Offset(0, -13),
                      child: const Text(
                        '23.120 Km',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              IndicatorsRow(),
              Transform.translate(
                offset: const Offset(0, -40),
                child: RecommendationsSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
