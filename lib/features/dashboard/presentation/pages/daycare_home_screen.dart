import 'package:flutter/material.dart';
import 'package:kinder_pet/core/config/theme.dart';
import 'package:kinder_pet/features/spa/presentation/pages/spa_screen.dart';
import 'package:kinder_pet/shared/widgets/common_drawer.dart';
import 'package:kinder_pet/features/dashboard/presentation/pages/daycare_dashboard_screen.dart';
import 'package:kinder_pet/features/pets_daycare/presentation/pages/pets_daycare_screen.dart';

class DaycareHomeScreen extends StatefulWidget {
  const DaycareHomeScreen({super.key});

  @override
  State<DaycareHomeScreen> createState() => _DaycareHomeScreenState();
}

class _DaycareHomeScreenState extends State<DaycareHomeScreen> {
  String _selectedPage = 'dashboard';

  void _navigateTo(String page) {
    setState(() {
      _selectedPage = page;
    });
    Navigator.pop(context);
  }

  Widget _getCurrentPage() {
    switch (_selectedPage) {
      case 'petsDaycare':
        return const PetsDaycareScreen();
      case 'spa':
        return const SpaScreen();
      case 'dashboard':
      default:
        return const DaycareDashboardScreen();
    }
  }

  String _getTitle() {
    switch (_selectedPage) {
      case 'petsDaycare':
        return 'Ingresar Mascota';
      case 'spa':
        return 'Spa Calendar';
      case 'dashboard':
      default:
        return 'Daycare Pets';
    }
  }

  /// Intercepta el botón de retroceso del sistema (Android)
  /// para volver siempre al dashboard, en lugar de salir directamente.
  Future<bool> _onWillPop() async {
    if (_selectedPage != 'dashboard') {
      setState(() => _selectedPage = 'dashboard');
      return false; // Evita cerrar la app
    }
    return true; // Permite salir si ya está en el dashboard
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColors.warmBeige,
        drawer: CommonDrawer(onNavigate: _navigateTo),
        appBar: AppBar(
          backgroundColor: AppColors.warmBeige,
          elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu, color: AppColors.brownText),
            ),
          ),
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              _getTitle(),
              style: const TextStyle(
                color: AppColors.brownText,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
        ),
        body: _getCurrentPage(),
      ),
    );
  }
}
