import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kinder_pet/app.dart';
import 'package:kinder_pet/features/auth/data/repositories/auth_repository.dart';
import 'package:kinder_pet/features/auth/data/services/auth_service.dart';
import 'package:kinder_pet/features/auth/presentation/pages/auth/signin/bloc/sign_in_bloc.dart';
import 'package:kinder_pet/features/dashboard/data/repository/daycare_event_repository.dart';
import 'package:kinder_pet/features/dashboard/data/service/daycare_event_service.dart';
import 'package:kinder_pet/features/dashboard/presentation/bloc/daycare_event_bloc.dart';
import 'package:kinder_pet/features/pets/data/repository/pet_repository.dart';
import 'package:kinder_pet/features/pets/data/service/pet_service.dart';
import 'package:kinder_pet/features/pets/logic/pet_search_cubit.dart';
import 'package:kinder_pet/features/pets_daycare/data/repository/daycare_repository.dart';
import 'package:kinder_pet/features/pets_daycare/data/service/daycare_service.dart';
import 'package:kinder_pet/features/pets_daycare/presentation/cubit/navigation_cubit.dart';
import 'package:kinder_pet/features/spa-appointment/cubit/spa_appointment_cubit.dart';
import 'package:kinder_pet/features/spa-appointment/data/repository/spa_appointment_repository.dart';
import 'package:kinder_pet/features/spa-appointment/data/service/spa_appointment_service.dart';

final authService = AuthService();
final authRepository = AuthRepository(authService);

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  await initializeDateFormatting('es_CO', null);

  final daycareEventRepository = DaycareEventRepository(
    DaycareEventService(),
    authRepository,
  );
  final daycareRepository = DaycareRepository(DaycareService(), authRepository);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SignInBloc(authRepository)),
        BlocProvider(
          create: (_) =>
              PetSearchCubit(PetRepository(PetService(), authRepository)),
        ),
        BlocProvider(
          create: (_) => SpaAppointmentCubit(
            SpaAppointmentRepository(SpaAppointmentService(), authRepository),
          ),
        ),

        // <-- AÑADIR A NIVEL APP: DaycareEventBloc
        BlocProvider(
          create: (_) =>
              DaycareEventBloc(daycareEventRepository, daycareRepository)
                ..add(FetchDaycareEvents()),
        ),

        // si necesitas NavigationCubit global:
        BlocProvider(create: (_) => NavigationCubit()),
      ],
      child: const KinderPet(),
    ),
  );
}
