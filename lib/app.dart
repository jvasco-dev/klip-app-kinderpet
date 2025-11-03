import 'package:flutter/material.dart';
import 'package:kinder_pet/core/config/routes.dart';
import 'package:kinder_pet/core/config/theme.dart';

class KinderPet extends StatelessWidget {
  const KinderPet({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KinderPet',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.signIn,
      routes: AppRoutes.appRoutes
    );
  }
}