import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design system Gab'Pharma (patient / livreur).
class Design {
  Design._();

  // —— Couleurs (maquette) ——
  static const Color primaire = Color(0xFF6C3AED); // violet patient
  static const Color secondaire = Color(0xFF16A34A); // vert
  static const Color neutreFonce = Color(0xFF0F172A);
  static const Color neutreClair = Color(0xFFF3F4F6);
  static const Color alerte = Color(0xFFEF4444);
  static const Color attention = Color(0xFFF59E0B);
  static const Color information = Color(0xFF3B82F6);
  static const Color succes = Color(0xFF10B981);
  static const Color surface = Color(0xFFEBF7EE);

  // —— Alias métier / legacy ——
  static const Color violetPatient = primaire;
  static const Color vert = Color(0xFF228545);
  static const Color vertFonce = Color(0xFF015533);
  static const Color lime = Color(0xFF8DC63F);
  static const Color blanc = Color(0xFFFFFFFF);
  static const Color fond = Color(0xFFF1F5F9);
  static const Color texte = neutreFonce;
  static const Color texteSecondaire = Color(0xFF64748B);
  static const Color bordure = Color(0xFFE5E7EB);
  static const Color erreur = alerte;
  static const Color warning = attention;

  // —— Rayons ——
  static const double radiusXs = 4;
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
  static const double radiusPill = 999;

  // —— Espacements (grille 8) ——
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s24 = 24;
  static const double s32 = 32;
  static const double s64 = 64;

  static TextStyle get h1 => GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: texte,
        height: 1.2,
      );

  static TextStyle get h2 => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: texte,
        height: 1.25,
      );

  static TextStyle get h3 => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: texte,
      );

  static TextStyle get h4 => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: texte,
      );

  static TextStyle get body1 => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: texte,
      );

  static TextStyle get body2 => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: texteSecondaire,
      );

  static TextStyle get caption => GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: texteSecondaire,
      );

  static ThemeData get theme {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaire,
        primary: primaire,
        secondary: secondaire,
        tertiary: lime,
        surface: fond,
        error: alerte,
      ),
      scaffoldBackgroundColor: fond,
    );

    return base.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).apply(
        bodyColor: texte,
        displayColor: texte,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: blanc,
        foregroundColor: texte,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: h4.copyWith(fontWeight: FontWeight.w600),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primaire;
          return blanc;
        }),
        checkColor: WidgetStateProperty.all(blanc),
        side: const BorderSide(color: bordure, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXs),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaire,
        foregroundColor: blanc,
      ),
    );
  }
}
