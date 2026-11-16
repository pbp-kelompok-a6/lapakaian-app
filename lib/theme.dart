import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const ink = Color(0xFF111111);
  static const bg = Color(0xFFF6F3EE);
  static const border = Color(0xFFD8D2C7);
  static const muted = Color(0xFF6B665E);
  static const hint = Color(0xFF8F897F);
}

ThemeData buildTheme() {
  OutlineInputBorder outline(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: c),
      );

  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.ink,
      primary: AppColors.ink,
      surface: AppColors.bg,
    ),
    textTheme: TextTheme(
      headlineMedium: GoogleFonts.archivo(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.28,
        color: AppColors.ink,
      ),
      labelLarge: GoogleFonts.archivo(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.ink,
      ),
      bodyLarge: GoogleFonts.inter(fontSize: 15, color: AppColors.ink),
      bodyMedium: GoogleFonts.inter(fontSize: 14, color: AppColors.ink),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      hintStyle: const TextStyle(color: AppColors.hint, fontSize: 15),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: outline(AppColors.border),
      enabledBorder: outline(AppColors.border),
      focusedBorder: outline(AppColors.ink),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.ink,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(48),
        shape: const StadiumBorder(),
        textStyle: GoogleFonts.archivo(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.ink,
        minimumSize: const Size.fromHeight(48),
        side: const BorderSide(color: AppColors.ink),
        shape: const StadiumBorder(),
        textStyle: GoogleFonts.archivo(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),
  );
}