import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';

/// V3.0 Theme - Designer-provided Apple aesthetic
/// Reference: doc/design/20260705/HTML/*.html
///
/// Uses Inter as SF Pro Display alternative (Google Fonts)
/// - Calm, warm, premium feel
/// - No gamification, no celebration animations
/// - Editorial typography hierarchy
class AppTheme {
  AppTheme._();

  /// Build Inter-based text theme with optional brightness
  static TextTheme _buildTextTheme(Brightness brightness) {
    final baseTextTheme = brightness == Brightness.dark
        ? ThemeData(brightness: Brightness.dark).textTheme
        : ThemeData(brightness: Brightness.light).textTheme;

    final isDark = brightness == Brightness.dark;
    final primary = isDark
        ? const Color(kColorDarkTextPrimary)
        : const Color(kColorTextPrimary);
    final secondary = isDark
        ? const Color(kColorDarkTextSecondary)
        : const Color(kColorTextSecondary);
    final muted = isDark
        ? const Color(kColorDarkTextHint)
        : const Color(kColorTextHint);

    final interTextTheme = GoogleFonts.interTextTheme(baseTextTheme);

    return interTextTheme.copyWith(
      displayLarge: GoogleFonts.inter(
        fontSize: 48,
        fontWeight: FontWeight.w600,
        color: primary,
        letterSpacing: -1.5,
        height: 1.05,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: primary,
        letterSpacing: -0.8,
        height: 1.1,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: primary,
        letterSpacing: -0.5,
        height: 1.15,
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: primary,
        letterSpacing: -0.4,
        height: 1.2,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 19,
        fontWeight: FontWeight.w600,
        color: primary,
        letterSpacing: -0.2,
        height: 1.25,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: primary,
        letterSpacing: -0.1,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: primary,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: secondary,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: muted,
        height: 1.4,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: secondary,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: muted,
        letterSpacing: 0.08,
      ),
    );
  }

  /// Mono font for technical labels (greetings, eyebrows, meta)
  static TextStyle _monoStyle({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    double letterSpacing = 0.12,
  }) {
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  /// Static mono style getter (used in screens)
  static TextStyle monoLabel({required Color color, double fontSize = 11}) =>
      _monoStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        color: color,
      );

  /// Tabular nums for numbers
  static TextStyle tabularNum({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
  }) {
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Color(kColorPrimary),
        secondary: Color(kColorPrimary),
        surface: Color(kColorSurface),
        error: Color(kColorDanger),
        onPrimary: Color(kColorTextOnPrimary),
        onSecondary: Color(kColorTextOnPrimary),
        onSurface: Color(kColorTextPrimary),
      ),
      scaffoldBackgroundColor: const Color(kColorBackground),
      textTheme: _buildTextTheme(Brightness.light),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(kColorBackground),
        foregroundColor: const Color(kColorTextPrimary),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: const Color(kColorTextPrimary),
          letterSpacing: -0.1,
        ),
        iconTheme: const IconThemeData(color: Color(kColorTextPrimary)),
      ),
      cardTheme: CardTheme(
        color: const Color(kColorSurface),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
          side: const BorderSide(color: Color(kColorBorder), width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(kColorPrimary),
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 48),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(kColorTextPrimary),
          side: const BorderSide(color: Color(kColorBorder), width: 1),
          elevation: 0,
          minimumSize: const Size(double.infinity, 48),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(kColorPrimary),
          minimumSize: const Size(44, 44),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(kColorSurface),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: const BorderSide(color: Color(kColorBorder), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: const BorderSide(color: Color(kColorBorder), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: const BorderSide(color: Color(kColorPrimary), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        hintStyle: GoogleFonts.inter(
          color: const Color(kColorTextHint),
          fontWeight: FontWeight.w400,
        ),
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: Color(kColorPrimary),
        inactiveTrackColor: Color(0xFFE3D9C4),
        thumbColor: Color(kColorPrimary),
        overlayColor: Color(0x330071E3),
        trackHeight: 4,
        thumbShape: RoundSliderThumbShape(
          enabledThumbRadius: 10,
          elevation: 2,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: const Color(kColorBorderSoft),
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(kColorTextPrimary),
        contentTextStyle: GoogleFonts.inter(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color(kColorBackground),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(kBorderRadiusLarge),
          ),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: const Color(kColorBackground),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(kColorBackground),
        selectedItemColor: Color(kColorPrimary),
        unselectedItemColor: Color(kColorTextHint),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(kColorPrimary),
        secondary: Color(kColorPrimary),
        surface: Color(kColorDarkSurface),
        error: Color(kColorDanger),
        onPrimary: Color(kColorTextOnPrimary),
        onSecondary: Color(kColorTextOnPrimary),
        onSurface: Color(kColorDarkTextPrimary),
      ),
      scaffoldBackgroundColor: const Color(kColorDarkBackground),
      textTheme: _buildTextTheme(Brightness.dark),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(kColorDarkBackground),
        foregroundColor: const Color(kColorDarkTextPrimary),
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: const Color(kColorDarkTextPrimary),
        ),
      ),
      cardTheme: CardTheme(
        color: const Color(kColorDarkSurface),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
          side: const BorderSide(color: Color(kColorDarkBorder), width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(kColorPrimary),
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(kColorDarkSurface),
        selectedItemColor: Color(kColorPrimary),
        unselectedItemColor: Color(kColorDarkTextHint),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}