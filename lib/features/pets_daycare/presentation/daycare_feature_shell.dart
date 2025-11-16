// lib/features/daycare/presentation/daycare_feature_shell.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder_pet/features/auth/data/repositories/auth_repository.dart';
import 'package:kinder_pet/features/auth/data/services/auth_service.dart';
import 'package:kinder_pet/features/dashboard/presentation/pages/daycare_home_screen.dart';
import 'package:kinder_pet/features/pets_daycare/data/repository/daycare_repository.dart';
import 'package:kinder_pet/features/pets_daycare/data/service/daycare_service.dart';
import 'package:kinder_pet/features/pets_daycare/presentation/bloc/daycare_bloc.dart';
import 'package:kinder_pet/features/pets_daycare/presentation/cubit/navigation_cubit.dart';
import 'package:kinder_pet/features/spa-appointment/cubit/spa_appointment_cubit.dart';
import 'package:kinder_pet/features/spa-appointment/data/repository/spa_appointment_repository.dart';
import 'package:kinder_pet/features/spa-appointment/data/service/spa_appointment_service.dart';


// Auth (para el token)


class DaycareFeatureShell extends StatelessWidget {
  const DaycareFeatureShell({super.key});

  @override
  Widget build(BuildContext context) {
    // Instancias reales (como hacías antes en cada pantalla)
    final authService = AuthService();
    final daycareService = DaycareService();
    final authRepo = AuthRepository(authService);
    final daycareRepo = DaycareRepository(daycareService, authRepo);
    final spaService = SpaAppointmentService();
    final spaRepo = SpaAppointmentRepository(spaService, authRepo);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => DaycareBloc(daycareRepo)..add( FetchDaycare()),
        ),
        BlocProvider(
          create: (_) => SpaAppointmentCubit(spaRepo)..loadAppointmentsForSelectedDay(),
        ),
        BlocProvider(create: (_) => NavigationCubit()),
      ],
      child: DaycareHomeScreen(),
    );
  }
}


