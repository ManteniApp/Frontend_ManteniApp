import 'package:flutter/material.dart';
import '../../domain/entities/motorcycle_entity.dart';
import '../widgets/motorcycle_card.dart';

class ListMotorcyclePage extends StatefulWidget {
  const ListMotorcyclePage({super.key});

  @override
  State<ListMotorcyclePage> createState() => _ListMotorcyclePageState();
}

class _ListMotorcyclePageState extends State<ListMotorcyclePage> {
  // Lista de motocicletas de ejemplo (en la implementación real vendría de un estado o servicio)
  List<MotorcycleEntity> motorcycles = [
    MotorcycleEntity(
      id: '1',
      name: 'Royal Enfield GRR 450',
      imageUrl:
          'https://example.com/motorcycle1.jpg', // Reemplaza con URLs reales
      brand: 'Royal Enfield',
      model: 'GRR 450',
    ),
    MotorcycleEntity(
      id: '2',
      name: 'Royal Enfield GRR 450',
      imageUrl: 'https://example.com/motorcycle2.jpg',
      brand: 'Royal Enfield',
      model: 'GRR 450',
    ),
    MotorcycleEntity(
      id: '3',
      name: 'Royal Enfield GRR 450',
      imageUrl: 'https://example.com/motorcycle3.jpg',
      brand: 'Royal Enfield',
      model: 'GRR 450',
    ),
    MotorcycleEntity(
      id: '4',
      name: 'Royal Enfield GRR 450',
      imageUrl: 'https://example.com/motorcycle4.jpg',
      brand: 'Royal Enfield',
      model: 'GRR 450',
    ),
    MotorcycleEntity(
      id: '5',
      name: 'Royal Enfield GRR 450',
      imageUrl: 'https://example.com/motorcycle5.jpg',
      brand: 'Royal Enfield',
      model: 'GRR 450',
    ),
    MotorcycleEntity(
      id: '6',
      name: 'Royal Enfield GRR 450',
      imageUrl: 'https://example.com/motorcycle6.jpg',
      brand: 'Royal Enfield',
      model: 'GRR 450',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // Contenido principal
          SafeArea(
            child: Column(
              children: [
                // Espacio para el header
                _buildHeader(),

                // Contenido principal con el container sobrepuesto
                Expanded(
                  child: Stack(
                    children: [
                      // Fondo con el container redondeado sobrepuesto
                      _buildOverlayContainer(),

                      // Botón flotante posicionado sobre el contenedor
                      Positioned(
                        bottom: 32,
                        right: 32,
                        child: FloatingActionButton(
                          onPressed: _addNewMotorcycle,
                          backgroundColor: const Color(0xFF2196F3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              100,
                            ), // Ajusta este valor para más o menos redondez
                          ),
                          child: const Icon(Icons.add, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // TODO: BARRA DE NAVEGACIÓN FLOTANTE - Será agregada desde otra feature
          // Posicionada en la parte inferior, flotando sobre el contenido
          // _buildFloatingNavigationBar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    // TODO: HEADER TEMPORAL - Será reemplazado por el header de la otra feature
    // Este header será reemplazado por el componente compartido de la otra rama
    return Container(
      height: 80,
      width: double.infinity,
      decoration: const BoxDecoration(color: Color(0xFF2196F3)),
      child: const Center(
        child: Text(
          'Mis Motocicletas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildOverlayContainer() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título del contenedor
            const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Lista de Motocicletas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                ),
              ),
            ),

            // Grid de motocicletas
            Expanded(
              child: motorcycles.isEmpty
                  ? _buildEmptyState()
                  : _buildMotorcycleGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMotorcycleGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: motorcycles.length,
      itemBuilder: (context, index) {
        return MotorcycleCard(
          motorcycle: motorcycles[index],
          onDelete: () => _deleteMotorcycle(index),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.motorcycle, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No hay motocicletas registradas',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Toca el botón + para agregar una',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _deleteMotorcycle(int index) {
    setState(() {
      motorcycles.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Motocicleta eliminada correctamente'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _addNewMotorcycle() {
    // Aquí irías a la pantalla de agregar nueva motocicleta
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Función para agregar nueva motocicleta'),
        backgroundColor: Color(0xFF2196F3),
      ),
    );
  }

  // TODO: MÉTODO PARA BARRA DE NAVEGACIÓN FLOTANTE
  // Descomenta cuando el componente esté disponible desde la otra feature
  /*
  Widget _buildFloatingNavigationBar() {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: FloatingNavigationBar(
        // Parámetros que probablemente tendrá el componente compartido
        currentIndex: 0, // Índice de la pantalla actual
        onTap: (index) {
          // Navegación entre pantallas
        },
        items: [
          // Los items de navegación que vendrán de la otra feature
        ],
      ),
    );
  }
  */
}
