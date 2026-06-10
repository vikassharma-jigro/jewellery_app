import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const gold = Color(0xFFC9A227);
  static const goldDark = Color(0xFF8C6E1F);
  static const goldLight = Color(0xFFF6E7A8);
  static const bg = Color(0xFFFAF8F2);
  static const ink = Color(0xFF1C1A14);
  static const muted = Color(0xFF7A7565);
  static const surface = Colors.white;
  static const success = Color(0xFF1B7F5A);
  static const danger = Color(0xFFC0392B);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: gold,
          primary: gold,
          secondary: goldDark,
          surface: surface,
        ),
        textTheme: GoogleFonts.poppinsTextTheme().apply(
          bodyColor: ink,
          displayColor: ink,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: bg,
          foregroundColor: ink,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          color: surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Color(0xFFEFE8D2)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE6DEC4)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE6DEC4)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: gold, width: 1.5),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: gold,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      );
}

// Constants for legacy/merged presentation screens
const kGold = AppTheme.gold;
const kGoldSoft = AppTheme.goldLight;
const kText = AppTheme.ink;
const kMuted = AppTheme.muted;
const kCard = AppTheme.surface;
const kCardHigh = Color(0xFFF5F5F5);
const kDivider = Color(0xFFE0E0E0);
const kError = AppTheme.danger;
const kBg = AppTheme.bg;
const kCard2 = Color(0xFFFAFAFA);
const kGoldContainer = Color(0xFFFBF8F1);
