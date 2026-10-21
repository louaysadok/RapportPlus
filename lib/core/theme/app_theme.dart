import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// MINIMAL THEME — pure monochrome, no purple, no surfaceTint
/// Light: white/paper + ink, Dark: #0A0A0A/#1A1A1A + white, both with 1px line

class AppTheme {
  // ── Minimal Palette ──
  static const Color ink = Color(0xFF111111);
  static const Color inkSoft = Color(0xFF2B2B2B);
  static const Color muted = Color(0xFF8A8F98);
  static const Color muted2 = Color(0xFFB0B5C0);
  static const Color line = Color(0xFFE9EBEE);
  static const Color lineStrong = Color(0xFFDDE0E5);
  static const Color paper = Color(0xFFFAFAF9);
  static const Color cardBg = Colors.white;
  static const Color accent = Color(0xFF111111);
  static const Color accentSubtle = Color(0xFFF3F4F5);
  static const Color success = Color(0xFF1A7F4A);
  static const Color warning = Color(0xFFB45309);
  static const Color error = Color(0xFFE5484D);

  // Dark minimal (pure neutral, no purple)
  static const Color darkScaffold = Color(0xFF0A0A0A);
  static const Color darkCard = Color(0xFF1A1A1A);
  static const Color darkLine = Color(0xFF2A2A2A);
  static const Color darkLineStrong = Color(0xFF333333);
  static const Color darkMuted = Color(0xFF9AA0AA);
  static const Color darkMuted2 = Color(0xFF6B7280);

  // Legacy aliases
  static const Color navy = ink;
  static const Color navyLight = inkSoft;
  static const Color blueSoft = ink;
  static const Color blueAccent = inkSoft;
  static const Color turquoise = ink;
  static const Color turquoiseLight = accentSubtle;
  static const Color surfaceLight = paper;
  static const Color surfaceCard = cardBg;
  static const Color textDark = ink;
  static const Color textMuted = muted;
  static const Color borderLight = line;

  static ThemeData lightTheme() {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      colorScheme: const ColorScheme.light(
        primary: ink,
        onPrimary: Colors.white,
        primaryContainer: inkSoft,
        secondary: ink,
        onSecondary: Colors.white,
        surface: paper,
        onSurface: ink,
        error: error,
        outline: line,
        surfaceTint: Colors.transparent, // no purple shading
      ),
      scaffoldBackgroundColor: paper,
      canvasColor: Colors.white,
      dividerColor: line,
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w700, color: ink, letterSpacing: -0.5),
        titleLarge: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: ink, letterSpacing: -0.3),
        titleMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: ink),
        bodyLarge: GoogleFonts.inter(fontSize: 14, color: ink, height: 1.6),
        bodyMedium: GoogleFonts.inter(fontSize: 13, color: muted, height: 1.5),
        labelLarge: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: ink),
        iconTheme: const IconThemeData(color: ink, size: 20),
      ),
      cardTheme: CardTheme(
        color: cardBg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: line, width: 1)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        indicatorColor: ink,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.selected)
            ? GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: ink)
            : GoogleFonts.inter(fontSize: 11, color: muted)),
        iconTheme: WidgetStateProperty.resolveWith((states) => IconThemeData(color: states.contains(WidgetState.selected) ? Colors.white : muted, size: 22)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: Colors.white, selectedItemColor: ink, unselectedItemColor: muted, type: BottomNavigationBarType.fixed, elevation: 0),
      elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(backgroundColor: ink, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 48), elevation: 0, surfaceTintColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), textStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600))),
      outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(foregroundColor: ink, side: const BorderSide(color: lineStrong, width: 1), minimumSize: const Size(double.infinity, 48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), textStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500))),
      textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: ink, textStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500))),
      inputDecorationTheme: InputDecorationTheme(
        filled: true, fillColor: Colors.white,
        hintStyle: GoogleFonts.inter(fontSize: 13, color: muted2),
        labelStyle: GoogleFonts.inter(fontSize: 12, color: muted, fontWeight: FontWeight.w500),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: line)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: line)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: ink, width: 1)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      chipTheme: ChipThemeData(backgroundColor: Colors.white, selectedColor: ink, labelStyle: GoogleFonts.inter(fontSize: 12), side: const BorderSide(color: line), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
      dividerTheme: const DividerThemeData(color: line, thickness: 1, space: 1),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? Colors.white : Colors.white),
        trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? ink : const Color(0xFFE5E7EB)),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
    );
  }

  static ThemeData darkTheme() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      colorScheme: const ColorScheme.dark(
        primary: Colors.white,
        onPrimary: ink,
        primaryContainer: Colors.white,
        secondary: Colors.white,
        onSecondary: ink,
        surface: darkScaffold,
        onSurface: Colors.white,
        error: error,
        outline: darkLine,
        surfaceTint: Colors.transparent,
      ),
      scaffoldBackgroundColor: darkScaffold,
      canvasColor: darkCard,
      dividerColor: darkLine,
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        titleLarge: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        titleMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
        bodyLarge: GoogleFonts.inter(fontSize: 14, color: Colors.white, height: 1.6),
        bodyMedium: GoogleFonts.inter(fontSize: 13, color: darkMuted, height: 1.5),
        labelLarge: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: ink),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkScaffold,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        iconTheme: const IconThemeData(color: Colors.white, size: 20),
      ),
      cardTheme: CardTheme(
        color: darkCard,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: darkLine, width: 1)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: darkScaffold,
        surfaceTintColor: Colors.transparent,
        indicatorColor: Colors.white,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.selected)
            ? GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)
            : GoogleFonts.inter(fontSize: 11, color: darkMuted)),
        iconTheme: WidgetStateProperty.resolveWith((states) => IconThemeData(color: states.contains(WidgetState.selected) ? ink : darkMuted, size: 22)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: darkScaffold, selectedItemColor: Colors.white, unselectedItemColor: darkMuted, type: BottomNavigationBarType.fixed, elevation: 0),
      elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: ink, minimumSize: const Size(double.infinity, 48), elevation: 0, surfaceTintColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), textStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600))),
      outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: darkLineStrong, width: 1), minimumSize: const Size(double.infinity, 48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), textStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500))),
      textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: Colors.white)),
      inputDecorationTheme: InputDecorationTheme(
        filled: true, fillColor: darkCard,
        hintStyle: GoogleFonts.inter(fontSize: 13, color: darkMuted2),
        labelStyle: GoogleFonts.inter(fontSize: 12, color: darkMuted),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: darkLine)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: darkLine)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.white, width: 1)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      dividerTheme: const DividerThemeData(color: darkLine, thickness: 1, space: 1),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? ink : Colors.white),
        trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? Colors.white : darkLineStrong),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      chipTheme: ChipThemeData(backgroundColor: darkCard, selectedColor: Colors.white, labelStyle: GoogleFonts.inter(fontSize: 12, color: Colors.white), side: const BorderSide(color: darkLine), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
    );
  }
}
