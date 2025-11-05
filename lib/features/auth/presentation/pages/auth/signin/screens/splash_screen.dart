import 'package:flutter/material.dart';
import 'package:kinder_pet/core/config/routes.dart';
import 'package:kinder_pet/core/config/theme.dart';
import 'package:kinder_pet/features/auth/data/repositories/auth_repository.dart';
import 'package:kinder_pet/features/auth/data/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthRepository _authRepository = AuthRepository(AuthService());

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    // Pequeña animación de carga
    await Future.delayed(const Duration(seconds: 1));

    final loggedIn = await _authRepository.hasValidSession();

    if (!mounted) return;

    if (loggedIn) {
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.signIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.warmBeige,
      body: Center(
        child: CircularProgressIndicator(color: AppColors.brownText),
      ),
    );
  }
}
