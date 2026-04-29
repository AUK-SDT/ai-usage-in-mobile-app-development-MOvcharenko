import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Monochrome palette with a single warm accent
  static const Color ink = Color(0xFF0D0D0D);
  static const Color paper = Color(0xFFF5F2ED);
  static const Color muted = Color(0xFF8C8880);
  static const Color border = Color(0xFFDDD9D3);
  static const Color accent = Color(0xFFD4550A); // burnt orange
  static const Color accentLight = Color(0xFFFFF1EA);
  static const Color white = Color(0xFFFFFFFF);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: paper,
      colorScheme: const ColorScheme.light(
        primary: ink,
        secondary: accent,
        surface: white,
        onPrimary: white,
        onSurface: ink,
      ),
      textTheme: GoogleFonts.ibmPlexMonoTextTheme().copyWith(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: ink,
          letterSpacing: -0.5,
        ),
        titleLarge: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: ink,
        ),
        bodyLarge: GoogleFonts.ibmPlexMono(
          fontSize: 14,
          color: ink,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.ibmPlexMono(
          fontSize: 13,
          color: muted,
          height: 1.5,
        ),
        labelLarge: GoogleFonts.ibmPlexMono(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: ink,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: border, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: border, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: ink, width: 1.5),
        ),
        contentPadding: const EdgeInsets.all(16),
        hintStyle: GoogleFonts.ibmPlexMono(
          fontSize: 13,
          color: muted,
        ),
      ),
    );
  }
}
