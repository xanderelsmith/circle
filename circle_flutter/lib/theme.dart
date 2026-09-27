import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // ─────────────────────────────────────────────
  // BRAND COLORS
  // ─────────────────────────────────────────────

  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryBright = Color(0xFF7C4DFF);
  static const Color secondary = Color(0xFF3D7BFF);

  static const Color accent = Color(0xFF9B5CFF);
  static const Color cyan = Color(0xFF42D9FF);

  // ─────────────────────────────────────────────
  // BACKGROUNDS
  // ─────────────────────────────────────────────

  static const Color background = Color(0xFF050A16);
  static const Color surface = Color(0xFF0B1224);
  static const Color surfaceLight = Color(0xFF111A31);
  static const Color card = Color(0xFF0D162B); // Premium subtle hierarchy

  static const Color glass = Color(0x66121C35);

  // ─────────────────────────────────────────────
  // TEXT
  // ─────────────────────────────────────────────

  static const Color textPrimary = Color(0xFFF7F8FF);
  static const Color textSecondary = Color(0xFFAAB4D0);
  static const Color textMuted = Color(0xFF6F7B9A);

  // ─────────────────────────────────────────────
  // STATUS
  // ─────────────────────────────────────────────

  static const Color success = Color(0xFF35D49A);
  static const Color warning = Color(0xFFFFB84D);
  static const Color danger = Color(0xFFFF5577);

  // ─────────────────────────────────────────────
  // STREAK / GAMIFICATION
  // ─────────────────────────────────────────────

  static const Color fire = Color(0xFFFF8A3D);
  static const Color gold = Color(0xFFFFC94A);

  // ─────────────────────────────────────────────
  // GRADIENTS
  // ─────────────────────────────────────────────

  static const LinearGradient atmosphericBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF07101F), // Slightly blue
      Color(0xFF050A16), // Deep navy
      Color(0xFF08091A), // Subtle purple
    ],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color(0xFF7B4DFF),
      Color(0xFF3D7BFF),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [
      Color(0xFF9B5CFF),
      Color(0xFF5B5CFF),
    ],
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [
      Color(0xFF121C38),
      Color(0xFF0B1329),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─────────────────────────────────────────────
  // THEME
  // ─────────────────────────────────────────────

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,

    scaffoldBackgroundColor: background,

    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: secondary,
      surface: surface,
      error: danger,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textPrimary,
    ),

    // ─────────────────────────────────────────
    // APP BAR
    // ─────────────────────────────────────────
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      foregroundColor: textPrimary,
      centerTitle: false,
    ),

    // ─────────────────────────────────────────
    // TEXT
    // ─────────────────────────────────────────
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: textPrimary,
        fontSize: 34,
        fontWeight: FontWeight.w700,
        letterSpacing: -1,
      ),

      displayMedium: TextStyle(
        color: textPrimary,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.7,
      ),

      headlineLarge: TextStyle(
        color: textPrimary,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),

      headlineMedium: TextStyle(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),

      titleLarge: TextStyle(
        color: textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),

      titleMedium: TextStyle(
        color: textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),

      bodyLarge: TextStyle(
        color: textPrimary,
        fontSize: 16,
      ),

      bodyMedium: TextStyle(
        color: textSecondary,
        fontSize: 14,
      ),

      bodySmall: TextStyle(
        color: textMuted,
        fontSize: 12,
      ),

      labelLarge: TextStyle(
        color: textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),

    // ─────────────────────────────────────────
    // INPUTS
    // ─────────────────────────────────────────
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceLight,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      ),

      hintStyle: const TextStyle(
        color: textMuted,
      ),

      labelStyle: const TextStyle(
        color: textSecondary,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: primary.withOpacity(.25),
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: primary.withOpacity(.20),
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: primary,
          width: 1.5,
        ),
      ),
    ),

    // ─────────────────────────────────────────
    // BUTTONS
    // ─────────────────────────────────────────
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,

        elevation: 0,

        minimumSize: const Size(
          double.infinity,
          54,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),

        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // ─────────────────────────────────────────
    // CARDS
    // ─────────────────────────────────────────
    cardTheme: CardThemeData(
      color: card,
      elevation: 0,
      margin: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: Colors.white.withOpacity(.06),
        ),
      ),
    ),

    // ─────────────────────────────────────────
    // DIVIDERS
    // ─────────────────────────────────────────
    dividerTheme: DividerThemeData(
      color: Colors.white.withOpacity(.06),
      thickness: 1,
    ),

    // ─────────────────────────────────────────
    // BOTTOM NAVIGATION
    // ─────────────────────────────────────────
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF080F20),
      elevation: 0,

      indicatorColor: primary.withOpacity(.18),

      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(
            color: primaryBright,
            size: 25,
          );
        }
        return IconThemeData(
          color: textMuted,
          size: 23,
        );
      }),

      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(
          color: primaryBright,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // ─────────────────────────────────────────
    // ICONS
    // ─────────────────────────────────────────
    iconTheme: const IconThemeData(
      color: textSecondary,
      size: 24,
    ),
  );
}
