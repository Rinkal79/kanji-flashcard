import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Palette
  static const Color inkBlack = Color(0xFF1A1A2E);
  static const Color deepIndigo = Color(0xFF16213E);
  static const Color accentIndigo = Color(0xFF533483);
  static const Color vermillion = Color(0xFFE94560);
  static const Color paperWarm = Color(0xFFF5F0E8);
  static const Color paperDark = Color(0xFFEDE7D9);
  static const Color inkGray = Color(0xFF6B7280);
  static const Color masteredGreen = Color(0xFF10B981);
  static const Color reviewAmber = Color(0xFFF59E0B);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: accentIndigo,
        secondary: vermillion,
        surface: deepIndigo,
        onPrimary: paperWarm,
        onSecondary: paperWarm,
        onSurface: paperWarm,
      ),
      scaffoldBackgroundColor: inkBlack,
      textTheme: GoogleFonts.notoSerifTextTheme(
        ThemeData.dark().textTheme,
      ).copyWith(
        displayLarge: GoogleFonts.notoSerif(
          color: paperWarm,
          fontSize: 96,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.5,
        ),
        headlineMedium: GoogleFonts.notoSerif(
          color: paperWarm,
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.notoSans(
          color: paperWarm,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.notoSans(
          color: inkGray,
          fontSize: 14,
        ),
        labelSmall: GoogleFonts.notoSans(
          color: inkGray,
          fontSize: 11,
          letterSpacing: 1.5,
          fontWeight: FontWeight.w500,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: inkBlack,
        foregroundColor: paperWarm,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.notoSerif(
          color: paperWarm,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
