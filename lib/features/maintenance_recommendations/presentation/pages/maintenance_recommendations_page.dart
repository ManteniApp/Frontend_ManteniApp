import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recommendation_provider.dart';
import '../widgets/recommendation_card.dart';

/// Página principal de recomendaciones de mantenimiento
class MaintenanceRecommendationsPage extends StatefulWidget {
  final String? motorcycleId;
  final String? motorcycleName;

  const MaintenanceRecommendationsPage({
    super.key,
    this.motorcycleId,
    this.motorcycleName,
  });

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
      // Cargar todas las recomendaciones disponibles
      provider.loadAllRecommendations();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
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

              return CustomScrollView(
                slivers: [
                  // AppBar flotante personalizado
                  SliverAppBar(
                    expandedHeight: 80,
                    floating: true,
                    pinned: false,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Color(0xFF2196F3),
                            size: 16,
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
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
                              horizontal: 60,
                              vertical: 16,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  '📋 Alertas y Recomendaciones',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  widget.motorcycleName ?? 'Generales',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Filtros flotantes
                  if (provider.categories.length > 1)
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF2196F3).withOpacity(0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: provider.categories.map((category) {
                              final isSelected =
                                  provider.selectedCategory == category ||
                                  (provider.selectedCategory == null &&
                                      category == 'Todas');

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    provider.setCategory(
                                      isSelected ? null : category,
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: isSelected
                                          ? const LinearGradient(
                                              colors: [
                                                Color(0xFF1976D2),
                                                Color(0xFF2196F3),
                                              ],
                                            )
                                          : null,
                                      color: isSelected
                                          ? null
                                          : Colors.grey[100],
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (isSelected)
                                          const Padding(
                                            padding: EdgeInsets.only(right: 6),
                                            child: Icon(
                                              Icons.check_circle,
                                              size: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        Text(
                                          category,
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : const Color(0xFF616161),
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),

                  // Lista de recomendaciones
                  SliverPadding(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return RecommendationCard(
                          recommendation: recommendations[index],
                        );
                      }, childCount: recommendations.length),
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
