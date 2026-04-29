import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Gemini palette with Google's signature blue accent
  static const Color ink = Color(0xFF202124);
  static const Color paper = Color(0xFFF8F9FC);
  static const Color muted = Color(0xFF5F6368);
  static const Color border = Color(0xFFE1E3E8);
  static const Color accent = Color(0xFF4285F4); // Google Blue
  static const Color accentLight = Color(0xFFE8F0FE);
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
        displayLarge: GoogleFonts.averageSans(
          fontSize: 32,
          fontWeight: FontWeight.w500,
          color: ink,
          letterSpacing: -0.5,
        ),
        titleLarge: GoogleFonts.averageSans(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: ink,
        ),
        bodyLarge: GoogleFonts.averageSans(
          fontSize: 14,
          color: ink,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.averageSans(
          fontSize: 13,
          color: muted,
          height: 1.5,
        ),
        labelLarge: GoogleFonts.averageSans(
          fontSize: 12,
          fontWeight: FontWeight.w500,
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
        hintStyle: GoogleFonts.averageSans(
          fontSize: 13,
          color: muted,
        ),
      ),
    );
  }
}