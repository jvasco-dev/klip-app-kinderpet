import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kinder_pet/app.dart';
import 'package:kinder_pet/features/auth/data/repositories/auth_repository.dart';
import 'package:kinder_pet/features/auth/data/services/auth_service.dart';
import 'package:kinder_pet/features/auth/presentation/pages/auth/signin/bloc/sign_in_bloc.dart';
import 'package:kinder_pet/features/pets/data/repository/pet_repository.dart';
import 'package:kinder_pet/features/pets/data/service/pet_service.dart';
import 'package:kinder_pet/features/pets/logic/pet_search_cubit.dart';

final authService = AuthService();
final authRepository = AuthRepository(authService);

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  await initializeDateFormatting('es_CO', null);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              PetSearchCubit(PetRepository(PetService(), authRepository)),
        ),
        BlocProvider(create: (_) => SignInBloc(authRepository)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return KinderPet();
  }
}
