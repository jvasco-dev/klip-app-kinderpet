import 'package:flutter/material.dart';
import 'package:kinder_pet/core/config/theme.dart';

class CommonDrawer extends StatelessWidget {
  const CommonDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.softWhite,
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
    );
  }
}
