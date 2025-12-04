import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'lista_paquetes_view.dart';
import 'mapa_view.dart';
import 'gestion_usuarios_view.dart';
import 'estadisticas_view.dart'; // JonthanAyala - Dio
import 'paquetes_cercanos_view.dart'; // JonthanAyala - Paquetes Cercanos
import 'perfil_view.dart';

// Vista principal con navegación
// Estructura base y navegación: Aserejex22 (líneas 1-40)
// Pestaña de usuarios para admin: JonthanAyala (líneas 25-75)
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final isAdmin = authViewModel.usuario?.rol == AppConstants.rolAdmin;

    // Páginas según el rol
    final List<Widget> pages = [
      const ListaPaquetesView(),
      const MapaView(),
      if (isAdmin) const EstadisticasView(), // JonthanAyala - Dio
      if (isAdmin) const GestionUsuariosView(),
      const PerfilView(),
    ];

    // Items del BottomNavigationBar según el rol
    final List<BottomNavigationBarItem> navItems = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.inventory_2_outlined),
        activeIcon: Icon(Icons.inventory_2),
        label: 'Paquetes',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.map_outlined),
        activeIcon: Icon(Icons.map),
        label: 'Mapa',
      ),
      if (isAdmin)
        const BottomNavigationBarItem(
          icon: Icon(Icons.analytics_outlined),
          activeIcon: Icon(Icons.analytics),
          label: 'Estadísticas',
        ),
      if (isAdmin)
        const BottomNavigationBarItem(
          icon: Icon(Icons.people_outlined),
          activeIcon: Icon(Icons.people),
          label: 'Usuarios',
        ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person_outlined),
        activeIcon: Icon(Icons.person),
        label: 'Perfil',
      ),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.surfaceColor,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.textSecondary,
        elevation: 8,
        items: navItems,
      ),
      // Botón flotante para repartidores - JonthanAyala
      floatingActionButton:
          authViewModel.usuario?.rol == AppConstants.rolRepartidor
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PaquetesCercanosView(),
                  ),
                );
              },
              backgroundColor: AppTheme.primaryColor,
              icon: const Icon(Icons.near_me),
              label: const Text('Cercanos'),
            )
          : null,
    );
  }
}
