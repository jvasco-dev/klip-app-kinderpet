

import 'package:flutter/material.dart';
import 'package:kinder_pet/core/config/routes.dart';
import 'package:kinder_pet/core/config/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    await Future.delayed(const Duration(seconds: 2)); // Simula carga
// Aquí iría tu lógica real

      Navigator.pushReplacementNamed(context, AppRoutes.signIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pets, size: 64, color: AppColors.dogOrange),
            const SizedBox(height: 16),
            Text('Cargando...', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
