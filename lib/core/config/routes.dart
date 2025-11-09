import 'package:flutter/material.dart';
import 'package:kinder_pet/features/auth/presentation/pages/auth/signin/screens/sign_in_screen.dart';
import 'package:kinder_pet/features/auth/presentation/pages/auth/signin/screens/splash_screen.dart';
import 'package:kinder_pet/features/dashboard/presentation/pages/daycare_home_screen.dart';
import 'package:kinder_pet/features/user/presentation/screens/profile_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String signIn = '/sign-in';
  static const String userProfile = '/user-profile';
  // static const String dashboard = '/dashboard';
  static const String daycareHome = '/daycare';

  static final Map<String, WidgetBuilder> appRoutes = {
    splash: (context) => const SplashScreen(),
    signIn: (context) => SignInScreen(),
    userProfile: (context) => const ProfileScreen(),
    // dashboard: (context) => const DaycareDashboardScreen(),
    daycareHome: (context) => const DaycareHomeScreen(),
  };
}
