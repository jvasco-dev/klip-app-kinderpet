// lib/common/widgets/common_drawer.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder_pet/core/config/theme.dart';
import 'package:kinder_pet/features/pets_daycare/presentation/cubit/navigation_cubit.dart';
import 'package:package_info_plus/package_info_plus.dart';

class CommonDrawer extends StatelessWidget {
  /// Callback opcional usado por versiones antiguas (puedes eliminarlo después)
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

  void _navigate(BuildContext context, DaycareTab tab) {
    // 1. Primero: intenta usar el NavigationCubit (nuevo sistema)
    final navigationCubit = context.read<NavigationCubit>();
    if (navigationCubit != null) {
      navigationCubit.selectTab(tab);
      Navigator.pop(context); // cierra el drawer
      return;
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
                  const ListTile(
                    title: Text(
                      'Daycare',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  // Ingresar mascota
                  ListTile(
                    leading: const Icon(Icons.pets),
                    title: const Text('Ingresar mascota'),
                    onTap: () => _navigate(context, DaycareTab.petsDaycare),
                  ),

                  // Dashboard
                  ListTile(
                    leading: const Icon(Icons.dashboard),
                    title: const Text('Dashboard'),
                    onTap: () => _navigate(context, DaycareTab.dashboard),
                  ),

                  const Divider(),

                  // Spa / Calendario
                  const ListTile(
                    title: Text(
                      'Spa',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Calendario'),
                    onTap: () => _navigate(context, DaycareTab.spa),
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
                      // Sign out: sigue usando ruta porque sale del feature
                      Navigator.pushReplacementNamed(context, '/sign-in');
                    },
                  ),
                  const SizedBox(height: 8),
                  FutureBuilder<String>(
                    future: _getAppVersion(),
                    builder: (context, snapshot) {
                      final version = snapshot.data ?? 'Cargando versión...';
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
