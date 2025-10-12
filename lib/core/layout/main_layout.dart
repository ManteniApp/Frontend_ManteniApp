import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../../../features/auth/presentation/pages/bike_profile_page.dart';
import '../../../features/list_motorcicle/presentation/pages/list_motorcycle_page.dart';

class MainLayout extends StatefulWidget {
  final int initialIndex;
  final String? selectedAlert;

  const MainLayout({super.key, this.initialIndex = 1, this.selectedAlert});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  //////////////////////////////////////////////////////// 🔹 PAGINAS DEL MENU INFERIOR /////////////////////////////////////////////////////////////

  final List<Widget> _pages = const [
    Center(child: Text('Inicio')),
    ListMotorcyclePage(), // Aqui lo cambian por la pagina de motos (el listado) y ya ahi si que abra el perfil de moto
    Center(child: Text('Reportes')),
    Center(child: Text('Alertas')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                      ? 'Buenos días, Santiago!' // 🔶Cambiar por nombre del usuario logeado
                                      : _selectedIndex == 1
                                      ? 'Listado de Motos' // 🔶 Hacer Dinamico cuando se conecte con lo demas
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
                        icon: Icon(Icons.notifications_none_rounded, size: 28),
                      ),
                    ],
                  ),
                ),

                ////////////////////////////// 🔹 Contenido dinámico
                Expanded(
                  child: IndexedStack(index: _selectedIndex, children: _pages),
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
                    onTap: (index) => setState(() => _selectedIndex = index),
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
    );
  }
}
