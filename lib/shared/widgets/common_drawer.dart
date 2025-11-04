import 'package:flutter/material.dart';
import 'package:kinder_pet/core/config/routes.dart';
import 'package:kinder_pet/core/config/theme.dart';
import 'package:package_info_plus/package_info_plus.dart';

class CommonDrawer extends StatelessWidget {
  const CommonDrawer({super.key});

  Future<String> _getAppVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return '${info.version} (${info.buildNumber})';
    } catch (e) {
      return 'Versión desconocida';
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
                  ListTile(
                    leading: const Icon(Icons.pets),
                    title: const Text('Ingresar mascota'),
                    onTap: () {
                      // Navegar a ingreso
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.exit_to_app),
                    title: const Text('Finalizar daycare'),
                    onTap: () {
                      // Navegar a salida
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text(
                      'Spa',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Calendario'),
                    onTap: () {
                      // Navegar a calendario
                    },
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
                      // context.read<AuthBloc>().add(LoggedOut());
                      Navigator.pushReplacementNamed(context, AppRoutes.signIn);
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
