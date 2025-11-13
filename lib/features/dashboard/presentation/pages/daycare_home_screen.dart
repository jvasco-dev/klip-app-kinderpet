import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:kinder_pet/core/config/theme.dart';
import 'package:kinder_pet/features/auth/data/repositories/auth_repository.dart';
import 'package:kinder_pet/features/auth/data/services/auth_service.dart';
import 'package:kinder_pet/features/spa-appointment/data/service/spa_appointment_service.dart';
import 'package:kinder_pet/features/spa-appointment/data/repository/spa_appointment_repository.dart';
import 'package:kinder_pet/features/spa-appointment/presentation/widgets/spa_calendar_wrapper.dart';
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
        return SpaCalendarWrapper(
            spaRepository: SpaAppointmentRepository(SpaAppointmentService(Dio()),
                AuthRepository(AuthService())));
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

  void _onPopInvoked(bool didPop, Object? result) {
    // Si la navegación hacia atrás fue prevenida (porque no estábamos en el dashboard),
    // entonces cambiamos la página actual al dashboard.
    if (!didPop) {
      setState(() {
        _selectedPage = 'dashboard';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _selectedPage == 'dashboard',
      onPopInvokedWithResult: _onPopInvoked,
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
