import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import '../../domain/entities/motorcycle_entity.dart';
import '../widgets/motorcycle_card.dart';
import '../../../motorcycles/data/datasources/motorcycle_remote_data_source.dart';
import '../../../motorcycles/domain/entities/motorcycle_entity.dart';
import '../../../motorcycles/presentation/providers/motorcycle_provider.dart';

class ListMotorcyclePage extends StatefulWidget {
  final void Function(MotorcycleEntity) onOpenProfile;

  const ListMotorcyclePage({super.key, required this.onOpenProfile});

  @override
  State<ListMotorcyclePage> createState() => _ListMotorcyclePageState();
}

class _ListMotorcyclePageState extends State<ListMotorcyclePage> {
  final MotorcycleRemoteDataSourceImpl _dataSource =
      MotorcycleRemoteDataSourceImpl();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MotorcycleProvider>().loadMotorcycles();
    });
  }

  // NUEVO MÉTODO: Eliminar motocicleta del backend
  Future<void> _deleteMotorcycleFromBackend(
    String? motorcycleId,
    int index,
  ) async {
    // Validar que el ID no sea null
    if (motorcycleId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: ID de motocicleta no válido'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    try {
      // Llamar al método de eliminación del data source
      await _dataSource.deleteMotorcycle(motorcycleId);

      // Recargar las motos desde el Provider para actualizar todas las páginas
      if (mounted) {
        await context.read<MotorcycleProvider>().loadMotorcycles();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Motocicleta eliminada correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Manejar error en la eliminación
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar motocicleta: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MotorcycleProvider>(
      builder: (context, provider, child) {
        final motorcycles = provider.motorcycles;
        final isLoading = provider.isLoading;

        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: CustomScrollView(
            slivers: [
              // Header flotante personalizado
              SliverAppBar(
                expandedHeight: 80,
                floating: true,
                pinned: false,
                elevation: 0,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1976D2), Color(0xFF2196F3)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.motorcycle,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Mis Motocicletas',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Gestiona tu colección',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Contador de motos
              if (!isLoading && motorcycles.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF2196F3).withOpacity(0.2),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF2196F3,
                                ).withOpacity(0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF1976D2),
                                      Color(0xFF2196F3),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.two_wheeler,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${motorcycles.length} ${motorcycles.length == 1 ? "motocicleta" : "motocicletas"}',
                                style: const TextStyle(
                                  color: Color(0xFF2196F3),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Grid de motocicletas
              isLoading
                  ? const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF2196F3),
                        ),
                      ),
                    )
                  : motorcycles.isEmpty
                  ? SliverFillRemaining(child: _buildEmptyState())
                  : SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.8,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return MotorcycleCard(
                            motorcycle: motorcycles[index],
                            onDelete: () => _deleteMotorcycleFromBackend(
                              motorcycles[index].id,
                              index,
                            ),
                            onEdit: () => _editMotorcycle(motorcycles[index]),
                            onTap: () =>
                                widget.onOpenProfile(motorcycles[index]),
                          );
                        }, childCount: motorcycles.length),
                      ),
                    ),
            ],
          ),
          floatingActionButton: Container(
            margin: const EdgeInsets.only(bottom: 70),
            child: FloatingActionButton.extended(
              onPressed: _addNewMotorcycle,
              backgroundColor: const Color(0xFF2196F3),
              elevation: 6,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Agregar Moto',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2196F3).withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(Icons.motorcycle, size: 80, color: Colors.grey[300]),
          ),
          const SizedBox(height: 32),
          Text(
            'No hay motocicletas',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Comienza agregando tu primera moto',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _addNewMotorcycle,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 4,
            ),
            icon: const Icon(Icons.add, color: Colors.white, size: 24),
            label: const Text(
              'Agregar Motocicleta',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addNewMotorcycle() {
    // ✅ Usar rootNavigator: true para acceder al Navigator raíz
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed('/register-motorcycle').then((_) {
      context.read<MotorcycleProvider>().loadMotorcycles();
    });
  }

  // NUEVO MÉTODO: Editar motocicleta
  void _editMotorcycle(MotorcycleEntity motorcycle) {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed('/edit-motorcycle', arguments: motorcycle).then((_) {
      context
          .read<MotorcycleProvider>()
          .loadMotorcycles(); // Recargar lista después de editar
    });
  }

  // NUEVO MÉTODO: Abrir recomendaciones
  void _openRecommendations(MotorcycleEntity motorcycle) {
    Navigator.of(context, rootNavigator: true).pushNamed(
      '/maintenance-recommendations',
      arguments: {
        'motorcycleId': motorcycle.id,
        'motorcycleName': motorcycle.fullName,
      },
    );
  }
}
