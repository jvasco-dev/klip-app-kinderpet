import 'package:flutter/material.dart';
import 'package:kinder_pet/core/config/theme.dart';
import 'package:package_info_plus/package_info_plus.dart';

class CommonDrawer extends StatelessWidget {
  /// Callback opcional usado por DaycareHomeScreen para navegación interna
  final void Function(String page)? onNavigate;

  const CommonDrawer({super.key, this.onNavigate});

  Future<String> _getAppVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return '${info.version} (${info.buildNumber})';
    } catch (e) {
      return 'Versión desconocida';
    }
  }

  void _navigate(BuildContext context, String page) {
    if (onNavigate != null) {
      // navegación controlada por el Home (no cierra la vista principal)
      onNavigate!(page);
    } else {
      // fallback retrocompatible: cierra drawer y hace push por rutas
      Navigator.pop(context);
      switch (page) {
        case 'petsDaycare':
          Navigator.pushNamed(
            context,
            '/pets-daycare',
          ); // o AppRoutes.petsDaycare si lo importas
          break;
        case 'dashboard':
          Navigator.pushNamed(context, '/dashboard');
          break;
        case 'spa':
          Navigator.pushNamed(context, '/spa');
          break;
        default:
          Navigator.pushNamed(context, '/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.softWhite,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 32),
                children: [
                  ListTile(
                    title: const Text(
                      'Daycare',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  // Ingresar mascota
                  ListTile(
                    leading: const Icon(Icons.pets),
                    title: const Text('Ingresar mascota'),
                    onTap: () => _navigate(context, 'petsDaycare'),
                  ),

                  // Dashboard
                  ListTile(
                    leading: const Icon(Icons.dashboard),
                    title: const Text('Dashboard'),
                    onTap: () => _navigate(context, 'dashboard'),
                  ),

                  const Divider(),

                  // Spa / Calendario
                  ListTile(
                    title: const Text(
                      'Spa',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Calendario'),
                    onTap: () => _navigate(context, 'spa'),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.logout_outlined,
                      color: Colors.redAccent,
                    ),
                    title: const Text(
                      'Sign Out',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    onTap: () {
                      // Sign out: sigue usando rutas (o lanza evento de auth si lo prefieres)
                      Navigator.pushReplacementNamed(context, '/sign-in');
                    },
                  ),
                  const SizedBox(height: 8),
                  FutureBuilder<String>(
                    future: _getAppVersion(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text(
                          'Cargando versión...',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        );
                      }

                      final version = snapshot.data ?? 'Versión desconocida';
                      return Text(
                        'Versión $version',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
