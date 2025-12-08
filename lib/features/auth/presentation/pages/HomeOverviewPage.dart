import 'package:flutter/material.dart';
import 'package:frontend_manteniapp/features/auth/presentation/pages/bike_profile_page.dart';
import 'package:frontend_manteniapp/features/motorcycles/domain/entities/motorcycle_entity.dart';
import 'package:frontend_manteniapp/features/motorcycles/data/datasources/motorcycle_remote_data_source.dart';
import 'package:frontend_manteniapp/features/auth/presentation/widgets/recommendation_card.dart';
import 'package:frontend_manteniapp/core/layout/main_layout.dart';

class HomeOverviewPage extends StatefulWidget {
  const HomeOverviewPage({super.key});

  @override
  State<HomeOverviewPage> createState() => _HomeOverviewPageState();
}

class _HomeOverviewPageState extends State<HomeOverviewPage>
    with AutomaticKeepAliveClientMixin {
  final MotorcycleRemoteDataSourceImpl _dataSource =
      MotorcycleRemoteDataSourceImpl();
  List<MotorcycleEntity> motorcycles = [];
  bool _isLoading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadMotorcycles();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Recargar cuando la página vuelve a ser visible
    _loadMotorcycles();
  }

  Future<void> _loadMotorcycles() async {
    setState(() => _isLoading = true);
    try {
      final loaded = await _dataSource.getAllMotorcycles();
      if (mounted) {
        setState(() {
          motorcycles = loaded;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Requerido por AutomaticKeepAliveClientMixin
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadMotorcycles,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ////////////////////////////////////// LOGO + TÍTULO
                _buildSectionContainer(
                  title: "",
                  onSeeAll: () {},
                  child: Column(
                    children: [
                      Image.asset("assets/images/logo.png", height: 80),
                      const SizedBox(height: 8),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "Manteni",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: "App",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                ////////////////////////////////////// SECCIÓN MOTOS
                _buildSectionContainer(
                  title: "Motos",
                  onSeeAll: () {
                    MainLayout.of(
                      context,
                    )?.switchTab(1); // 👈 ir al tab de Motos
                  },
                  child: SizedBox(
                    height: 140,
                    child: motorcycles.isEmpty
                        ? const Center(
                            child: Text(
                              "No hay motos registradas",
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            itemCount: motorcycles.length,
                            itemBuilder: (context, index) {
                              final moto = motorcycles[index];
                              return GestureDetector(
                                onTap: () {
                                  final layoutState = MainLayout.of(context);
                                  final motosNavigator =
                                      layoutState?.navigatorKeys[1];

                                  // 👇 Primero abrimos el perfil dentro del tab de Motos
                                  motosNavigator?.currentState?.push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          BikeProfilePage(motorcycle: moto),
                                    ),
                                  );

                                  // 👇 Luego cambiamos la pestaña activa al tab de Motos
                                  Future.delayed(
                                    const Duration(milliseconds: 150),
                                    () {
                                      layoutState?.switchTab(1);
                                    },
                                  );
                                },
                                child: Container(
                                  width: 110,
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: moto.imageUrl.isNotEmpty
                                            ? ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.vertical(
                                                      top: Radius.circular(12),
                                                    ),
                                                child: Image.network(
                                                  moto.imageUrl,
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  loadingBuilder: (context, child, loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      print(
                                                        '✅ [HomeOverview] Imagen cargada: ${moto.imageUrl}',
                                                      );
                                                      return child;
                                                    }
                                                    return Center(
                                                      child: CircularProgressIndicator(
                                                        value:
                                                            loadingProgress
                                                                    .expectedTotalBytes !=
                                                                null
                                                            ? loadingProgress
                                                                      .cumulativeBytesLoaded /
                                                                  loadingProgress
                                                                      .expectedTotalBytes!
                                                            : null,
                                                      ),
                                                    );
                                                  },
                                                  errorBuilder: (context, error, stackTrace) {
                                                    print(
                                                      '❌ [HomeOverview] Error cargando imagen: ${moto.imageUrl}',
                                                    );
                                                    print('❌ Error: $error');
                                                    return Container(
                                                      color: Colors.white,
                                                      child: const Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons.motorcycle,
                                                              size: 40,
                                                              color: Colors
                                                                  .lightBlue,
                                                            ),
                                                            SizedBox(height: 4),
                                                            Text(
                                                              'Sin imagen',
                                                              style: TextStyle(
                                                                fontSize: 11,
                                                                color: Colors
                                                                    .lightBlue,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              )
                                            : Container(
                                                color: Colors.white,
                                                child: const Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.motorcycle,
                                                        size: 40,
                                                        color: Colors.lightBlue,
                                                      ),
                                                      SizedBox(height: 4),
                                                      Text(
                                                        "Sin imagen",
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          color:
                                                              Colors.lightBlue,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Text(
                                          moto.fullName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),

                ////////////////////////////////////////////////////// SECCIÓN ALERTAS
                _buildSectionContainer(
                  title: "Alertas",
                  onSeeAll: () {
                    MainLayout.of(context)?.switchTab(3);
                  },
                  child: Column(
                    children: [
                      RecommendationCard(
                        emoji: "⚠️",
                        title: "Revisión general recomendada",
                        description: "Antes de tu próximo viaje largo.",
                        type: RecommendationType.alert,
                        onTap: () {
                          MainLayout.of(
                            context,
                          )?.switchTab(3, alert: "Revisión general");
                        },
                      ),
                      RecommendationCard(
                        emoji: "🛠️",
                        title: "Mantenimiento eléctrico",
                        description: "Revisa el sistema eléctrico de tu moto.",
                        type: RecommendationType.recommendation,
                        onTap: () {
                          MainLayout.of(
                            context,
                          )?.switchTab(3, alert: "Mantenimiento eléctrico");
                        },
                      ),
                    ],
                  ),
                ),

                ////////////////////////////////////////////////////// SECCIÓN REPORTES
                _buildSectionContainer(
                  title: "Reportes Generales",
                  onSeeAll: () {
                    MainLayout.of(context)?.switchTab(2);
                  },
                  child: Column(
                    children: [
                      RecommendationCard(
                        emoji: "💡",
                        title: "Cambio de aceite sugerido",
                        description: "En menos de 300 km.",
                        type: RecommendationType.tip,
                        onTap: () {
                          MainLayout.of(
                            context,
                          )?.switchTab(2, alert: "Cambio de aceite");
                        },
                      ),
                      RecommendationCard(
                        emoji: "📊",
                        title: "Historial de mantenimientos",
                        description: "Consulta tus últimos reportes.",
                        type: RecommendationType.recommendation,
                        onTap: () {
                          MainLayout.of(
                            context,
                          )?.switchTab(2, alert: "Historial");
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 80), // espacio para menú inferior
              ],
            ),
          ), // Cierre de SingleChildScrollView
        ), // Cierre de RefreshIndicator
      ),
    );
  }

  Widget _buildSectionContainer({
    required String title,
    required VoidCallback onSeeAll,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 0, 81, 255).withOpacity(0.30),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (title.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color.fromARGB(130, 0, 42, 255),
                  ),
                  onPressed: onSeeAll,
                ),
              ],
            ),
          if (title.isNotEmpty) const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}
