import 'package:flutter/material.dart';

/// 🎨 Paleta de colores principal para Kinder Pet
class AppColors {
  // Base
  static const Color dogOrange = Color(
    0xFFF4A261,
  ); // Principal: botones y acentos
  static const Color lightDogOrange = Color(
    0xFFFFD1A8,
  ); // Nuevo: Tono claro de naranja
  static const Color darkOrangeHover = Color(0xFFE76F51); // Hover o error suave
  static const Color warmBeige = Color(0xFFFAF3E0); // Fondo general
  static const Color lightBeigeAccent = Color(
    0xFFFFF7ED,
  ); // Fondo secundario o tarjetas
  static const Color softWhite = Color(0xFFFFFFFF); // Formularios, cards

  // Texto y neutros
  static const Color brownText = Color(0xFF5B3A29); // Titulares
  static const Color warmBrown = Color(0xFF8D6E63); // Subtítulos o texto medio
  static const Color goldenTan = Color(
    0xFFD4A373,
  ); // Texto resaltado o secundario
  static const Color grayNeutral = Color(
    0xFFB8B8B8,
  ); // Placeholder, texto apagado
  static const Color hardText = Color(0xFF555353); // Texto fuerte o encabezados
  static const Color lightGray = Color(
    0xFFE0E0E0,
  ); // Nuevo: Gris claro para fondos o bordes
  static const Color darkGray = Color(
    0xFF616161,
  ); // Nuevo: Gris oscuro para texto o iconos

  // Feedback (estados)
  static const Color softAlert = Color(0xFFFF5252); // Error
  static const Color successGreen = Color(0xFF81C784); // Éxito
  static const Color warningAmber = Color(0xFFFFB74D); // Advertencia
  static const Color infoBlue = Color(0xFF64B5F6); // Información
}

/// 🌈 Tema global de la aplicación Kinder Pet
final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.warmBeige,

  colorScheme:
      ColorScheme.fromSeed(
        seedColor: AppColors.dogOrange,
        brightness: Brightness.light,
      ).copyWith(
        primary: AppColors.dogOrange,
        onPrimary: AppColors.softWhite,
        surface: AppColors.softWhite,
        onSurface: AppColors.brownText,
        secondary: AppColors.goldenTan,
        onSecondary: AppColors.softWhite,
        error: AppColors.softAlert,
      ),

  // 🧱 Botones principales
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: AppColors.dogOrange,
      foregroundColor: AppColors.softWhite,
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      minimumSize: const Size(double.infinity, 48),
    ),
  ),

  // 📝 Textos
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      color: AppColors.brownText,
      fontWeight: FontWeight.bold,
      fontSize: 28,
    ),
    headlineMedium: TextStyle(
      color: AppColors.hardText,
      fontWeight: FontWeight.w600,
      fontSize: 22,
    ),
    bodyLarge: TextStyle(color: AppColors.warmBrown, fontSize: 16),
    bodyMedium: TextStyle(color: AppColors.goldenTan, fontSize: 14),
    labelLarge: TextStyle(
      color: AppColors.brownText,
      fontWeight: FontWeight.w500,
      fontSize: 14,
    ),
  ),

  // 🧩 Campos de texto
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.softWhite,
    hintStyle: const TextStyle(color: AppColors.grayNeutral),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.grayNeutral, width: 1),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.dogOrange, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.softAlert, width: 1.5),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.softAlert, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
  ),

  // 🔔 SnackBars y mensajes
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: AppColors.softAlert,
    contentTextStyle: TextStyle(color: AppColors.softWhite),
    behavior: SnackBarBehavior.floating,
  ),

  // 🧭 AppBar
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.warmBeige,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: AppColors.brownText,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: AppColors.brownText),
    centerTitle: true,
  ),
);
