import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Deep space and vibrant neon gradients
  static const Color primaryColor = Color(0xFF7E3FF2);
  static const Color secondaryColor = Color(0xFF00E1D9);
  static const Color accentColor = Color(0xFFFF497B);
  
  static const Color backgroundColor = Color(0xFF0D0E15);
  static const Color cardColor = Color(0x33FFFFFF); // Glassmorphism white
  
  static const Color textDark = Color(0xFFE2E8F0);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFF94A3B8);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF7E3FF2), Color(0xFF00E1D9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF0D0E15), Color(0xFF1B1B2F)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: GoogleFonts.inter().fontFamily,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textLight),
        titleTextStyle: TextStyle(
          color: textLight,
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0x11FFFFFF), // Subtle glass input
        hintStyle: const TextStyle(color: textMuted),
        prefixIconColor: textMuted,
        suffixIconColor: textMuted,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0x33FFFFFF), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0x33FFFFFF), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: secondaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Color(0x22FFFFFF), width: 1),
        ),
        elevation: 0,
      ),
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: cardColor,
        onSurface: textLight,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF1B1B2F),
        selectedItemColor: secondaryColor,
        unselectedItemColor: textMuted,
        elevation: 20,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
