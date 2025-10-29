import 'package:flutter/material.dart';
//import '../../domain/entities/motorcycle_entity.dart';
import '../widgets/motorcycle_card.dart';
import '../../../motorcycles/data/datasources/motorcycle_remote_data_source.dart';
import '../../../motorcycles/domain/entities/motorcycle_entity.dart';

class ListMotorcyclePage extends StatefulWidget {
  final void Function(MotorcycleEntity) onOpenProfile;

  const ListMotorcyclePage({super.key, required this.onOpenProfile});

  @override
  State<ListMotorcyclePage> createState() => _ListMotorcyclePageState();
}

class _ListMotorcyclePageState extends State<ListMotorcyclePage> {
  final MotorcycleRemoteDataSourceImpl _dataSource =
      MotorcycleRemoteDataSourceImpl();

  List<MotorcycleEntity> motorcycles = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadMotorcycles();
  }

  Future<void> _loadMotorcycles() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final loadedMotorcycles = await _dataSource.getAllMotorcycles();

      setState(() {
        motorcycles = loadedMotorcycles
            .map(
              (model) => MotorcycleEntity(
                id: model.id,
                brand: model.brand,
                model: model.model,
                imageUrl: model.imageUrl,
                licensePlate: model.licensePlate,
                year: model.year ?? 0,
                displacement: model.displacement ?? 0,
                mileage: model.mileage ?? 0,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt,
              ),
            )
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar motocicletas: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [Expanded(child: _buildOverlayContainer())],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlayContainer() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 80.0),
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
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Expanded(
                  child: motorcycles.isEmpty && !_isLoading
                      ? _buildEmptyState()
                      : _buildMotorcycleGrid(),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: _addNewMotorcycle,
              backgroundColor: const Color(0xFF2196F3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMotorcycleGrid() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF2196F3)),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Error al cargar las motocicletas',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _loadMotorcycles,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
              ),
            ),
          ],
        ),
      );
    }

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
          onTap: () =>
              widget.onOpenProfile(motorcycles[index]), // 👈 usa callback
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
    // ✅ Usar rootNavigator: true para acceder al Navigator raíz
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed('/register-motorcycle').then((_) {
      _loadMotorcycles();
    });
  }
}
