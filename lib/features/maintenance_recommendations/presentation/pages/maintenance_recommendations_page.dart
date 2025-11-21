import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recommendation_provider.dart';
import '../widgets/recommendation_card.dart';

/// Página principal de recomendaciones de mantenimiento
class MaintenanceRecommendationsPage extends StatefulWidget {
  final String? motorcycleId;
  final String? motorcycleName;

  const MaintenanceRecommendationsPage({
    Key? key,
    this.motorcycleId,
    this.motorcycleName,
  }) : super(key: key);

  @override
  State<MaintenanceRecommendationsPage> createState() =>
      _MaintenanceRecommendationsPageState();
}

class _MaintenanceRecommendationsPageState
    extends State<MaintenanceRecommendationsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRecommendations();
    });
  }

  void _loadRecommendations() {
    final provider = context.read<MaintenanceRecommendationProvider>();
    if (widget.motorcycleId != null) {
      provider.loadMotorcycleRecommendations(widget.motorcycleId!);
    } else {
      provider.loadGeneralRecommendations();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.motorcycleName != null
              ? 'Recomendaciones - ${widget.motorcycleName}'
              : 'Recomendaciones Generales',
        ),
        backgroundColor: const Color(0xFF2196F3),
      ),
      body: Consumer<MaintenanceRecommendationProvider>(
        builder: (context, provider, child) {
          switch (provider.state) {
            case RecommendationState.loading:
              return const Center(child: CircularProgressIndicator());

            case RecommendationState.error:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error al cargar recomendaciones',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      provider.errorMessage ?? 'Error desconocido',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadRecommendations,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );

            case RecommendationState.loaded:
              final recommendations = provider.filteredRecommendations;

              if (recommendations.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No hay recomendaciones disponibles',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  // Filtro de categorías
                  if (provider.categories.length > 1)
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: provider.categories.length,
                        itemBuilder: (context, index) {
                          final category = provider.categories[index];
                          final isSelected =
                              provider.selectedCategory == category ||
                              (provider.selectedCategory == null &&
                                  category == 'Todas');

                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(category),
                              selected: isSelected,
                              onSelected: (selected) {
                                provider.setCategory(
                                  selected ? category : null,
                                );
                              },
                              selectedColor: const Color(
                                0xFF2196F3,
                              ).withOpacity(0.2),
                            ),
                          );
                        },
                      ),
                    ),

                  // Lista de recomendaciones
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async => _loadRecommendations(),
                      child: ListView.builder(
                        itemCount: recommendations.length,
                        itemBuilder: (context, index) {
                          return RecommendationCard(
                            recommendation: recommendations[index],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );

            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
