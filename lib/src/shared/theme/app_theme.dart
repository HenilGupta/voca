import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Strict monochrome high-contrast theme (WCAG 2.1 AA compliant).
class AppTheme {
  AppTheme._();

  // ───── Color Palette ─────
  static const Color _black = Colors.black;
  static const Color _white = Colors.white;
  static const Color _grey = Color(0xFF757575);

  static ThemeData get darkTheme {
    final base = ThemeData.dark();
    final textTheme = GoogleFonts.interTextTheme(base.textTheme).apply(
      bodyColor: _white,
      displayColor: _white,
    );

    return base.copyWith(
      scaffoldBackgroundColor: _black,
      colorScheme: const ColorScheme.dark(
        primary: _white,
        onPrimary: _black,
        secondary: _white,
        onSecondary: _black,
        surface: _black,
        onSurface: _white,
        error: Colors.redAccent,
        onError: _black,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: _black,
        foregroundColor: _white,
        elevation: 0,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: _black,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: _white, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _white,
          foregroundColor: _black,
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _white,
          side: const BorderSide(color: _white, width: 2),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      iconTheme: const IconThemeData(color: _white, size: 28),
      dividerTheme: const DividerThemeData(color: _grey, thickness: 1),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _black,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _white, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _grey, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _white, width: 3),
        ),
        labelStyle: const TextStyle(color: _white),
        hintStyle: TextStyle(color: _grey),
      ),

      // ───── Bold Focus Borders for Keyboard Navigation ─────
      focusColor: _white,
      hoverColor: _white.withValues(alpha: 0.1),
      splashColor: _white.withValues(alpha: 0.2),
      highlightColor: _white.withValues(alpha: 0.1),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return _white;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(_black),
        side: const BorderSide(color: _white, width: 2),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.all(_white),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(_white),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return _grey;
          return _black;
        }),
        trackOutlineColor: WidgetStateProperty.all(_white),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: _white,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(color: _black, fontWeight: FontWeight.w600),
      ),
    );
  }
}
