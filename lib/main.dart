import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder_pet/app.dart';
import 'package:kinder_pet/features/auth/presentation/pages/auth/signin/bloc/sign_in_bloc.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (_) => SignInBloc())],
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
