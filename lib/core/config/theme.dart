import 'package:flutter/material.dart';

class AppColors {
  static const Color dogOrange = Color(
    0xFFF4A261,
  ); // Botones principales, acentos
  static const Color warmBeige = Color(0xFFFAF3E0); // Fondo general
  static const Color brownText = Color(0xFF5B3A29); // Títulos y texto principal
  static const Color softWhite = Color(
    0xFFFFFFFF,
  ); // Fondos de formularios, tarjetas
  static const Color grayNeutral = Color(
    0xFFB8B8B8,
  ); // Placeholder, texto secundario

  // Colores opcionales
  static const Color darkOrangeHover = Color(0xFFE76F51);
  static const Color lightBeigeAccent = Color(0xFFFFF7ED);
}

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.warmBeige,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.dogOrange,
    brightness: Brightness.light,
  ).copyWith(
    primary: AppColors.dogOrange,
    onPrimary: AppColors.softWhite,
    surface: AppColors.softWhite,
    onSurface: AppColors.brownText,
    secondary: AppColors.brownText,
    onSecondary: AppColors.softWhite,
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: AppColors.dogOrange,
      foregroundColor: AppColors.softWhite,
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
);

