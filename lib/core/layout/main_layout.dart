import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../../features/list_motorcicle/presentation/pages/list_motorcycle_page.dart';
import '../../../features/auth/presentation/pages/bike_profile_page.dart';
import '../../../features/list_motorcicle/domain/entities/motorcycle_entity.dart';

class MainLayout extends StatefulWidget {
  final int initialIndex;
  final String? selectedAlert;

  const MainLayout({super.key, this.initialIndex = 0, this.selectedAlert});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int _selectedIndex;

  // 🔑 Claves para cada Navigator anidado
  final _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  // 🔹 Páginas principales con navegadores anidados
  List<Widget> get _pages => [
        _buildTabNavigator(
          key: _navigatorKeys[0],
          child: const Center(child: Text('Inicio')),
        ),
        _buildTabNavigator(
          key: _navigatorKeys[1],
          child: ListMotorcyclePage(
            onOpenProfile: (MotorcycleEntity moto) {
              _navigatorKeys[1].currentState?.push(
                MaterialPageRoute(
                  builder: (_) => BikeProfilePage(motorcycle: moto),
                ),
              );
            },
          ),
        ),
        _buildTabNavigator(
          key: _navigatorKeys[2],
          child: const Center(child: Text('Reportes')),
        ),
        _buildTabNavigator(
          key: _navigatorKeys[3],
          child: const Center(child: Text('Alertas')),
        ),
      ];

  Widget _buildTabNavigator({
    required GlobalKey<NavigatorState> key,
    required Widget child,
  }) {
    return Navigator(
      key: key,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // 🔹 Permite que el botón "atrás" retroceda dentro del tab actual
      onWillPop: () async {
        final nav = _navigatorKeys[_selectedIndex].currentState!;
        if (nav.canPop()) {
          nav.pop();
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  ///////////////////////////////////////////////// 🔹 HEADER GLOBAL /////////////////////////////////////////////////
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage(
                                  'assets/images/profile.png',
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _selectedIndex == 0
                                      ? 'Inicio'
                                      : _selectedIndex == 1
                                          ? 'Motos'
                                          : _selectedIndex == 2
                                              ? 'Reportes'
                                              : 'Alertas',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                ),
                                Transform.translate(
                                  offset: const Offset(0, -5),
                                  child: Text(
                                    _selectedIndex == 0
                                        ? 'Buenos días, Santiago!'
                                        : _selectedIndex == 1
                                            ? 'Listado de Motos'
                                            : _selectedIndex == 2
                                                ? 'Mis Reportes'
                                                : 'Mis Alertas',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.notifications_none_rounded,
                              size: 28),
                        ),
                      ],
                    ),
                  ),

                  ////////////////////////////// 🔹 Contenido dinámico
                  Expanded(
                    child: IndexedStack(
                      index: _selectedIndex,
                      children: _pages,
                    ),
                  ),
                ],
              ),
            ),

            //////////////////////////////////// 🔹 MENÚ INFERIOR (Salomon) ////////////////////////////////////
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                bottom: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(184, 255, 255, 255),
                      borderRadius: BorderRadius.circular(45),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2196F3).withOpacity(0.25),
                          blurRadius: 18,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: SalomonBottomBar(
                      currentIndex: _selectedIndex,
                      onTap: (index) =>
                          setState(() => _selectedIndex = index),
                      selectedItemColor: const Color(0xFF1976D2),
                      unselectedItemColor: Colors.black54,
                      itemPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      items: [
                        SalomonBottomBarItem(
                          icon: const Icon(Icons.home_outlined),
                          title: const Text("Inicio"),
                        ),
                        SalomonBottomBarItem(
                          icon: const Icon(Icons.motorcycle_outlined),
                          title: const Text("Motos"),
                        ),
                        SalomonBottomBarItem(
                          icon: const Icon(Icons.insert_chart_outlined_rounded),
                          title: const Text("Reportes"),
                        ),
                        SalomonBottomBarItem(
                          icon: const Icon(Icons.notifications_outlined),
                          title: const Text("Alertas"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}