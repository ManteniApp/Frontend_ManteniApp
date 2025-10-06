import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../../../features/auth/presentation/pages/bike_profile_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 1;

  final List<Widget> _pages = const [
    Center(child: Text('Inicio')),
    BikeProfilePage(),
    Center(child: Text('Reportes')),
    Center(child: Text('Alertas')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 Header global
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                          const Text(
                            'Tus Motos',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            _selectedIndex == 0
                                ? 'Inicio'
                                : _selectedIndex == 1
                                ? 'Perfil de Moto'
                                : _selectedIndex == 2
                                ? 'Reportes'
                                : 'Alertas',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Icon(Icons.notifications_none_rounded, size: 28),
                ],
              ),
            ),

            // 🔹 Contenido dinámico
            Expanded(
              child: IndexedStack(index: _selectedIndex, children: _pages),
            ),
          ],
        ),
      ),

      // 🔹 Menú inferior profesional (Salomon)
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2196F3).withOpacity(0.35),
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
          itemPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
    );
  }
}
