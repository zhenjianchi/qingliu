import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';

/// V2.0 Theme - Lingo Design System
/// Reference: https://open-design.ai/plugins/design-system-lingo/
class AppTheme {
  AppTheme._();

  /// Build Nunito-based text theme with optional brightness
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

    return GoogleFonts.nunitoTextTheme(baseTextTheme).copyWith(
      displayLarge: GoogleFonts.nunito(
        fontSize: 72,
        fontWeight: FontWeight.w900,
        color: primary,
        height: 1.0,
        letterSpacing: -2,
      ),
      displayMedium: GoogleFonts.nunito(
        fontSize: 56,
        fontWeight: FontWeight.w900,
        color: primary,
        height: 1.0,
        letterSpacing: -1.5,
      ),
      displaySmall: GoogleFonts.nunito(
        fontSize: 44,
        fontWeight: FontWeight.w800,
        color: primary,
        height: 1.05,
        letterSpacing: -1,
      ),
      headlineLarge: GoogleFonts.nunito(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: primary,
        height: 1.2,
      ),
      headlineMedium: GoogleFonts.nunito(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: primary,
        height: 1.3,
      ),
      headlineSmall: GoogleFonts.nunito(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      titleLarge: GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: primary,
      ),
      titleMedium: GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      titleSmall: GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      bodyLarge: GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: primary,
        height: 1.55,
      ),
      bodyMedium: GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: secondary,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: secondary,
        height: 1.4,
      ),
      labelLarge: GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      labelMedium: GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      labelSmall: GoogleFonts.nunito(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: secondary,
        letterSpacing: 1.0,
      ),
    );
  }

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Color(kColorPrimary),
        secondary: Color(kColorSecondary),
        tertiary: Color(kColorAccent),
        surface: Color(kColorSurface),
        error: Color(kColorError),
        onPrimary: Color(kColorTextOnPrimary),
        onSecondary: Colors.white,
        onTertiary: Colors.white,
        onSurface: Color(kColorTextPrimary),
      ),
      scaffoldBackgroundColor: const Color(kColorBackground),
      textTheme: _buildTextTheme(Brightness.light),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(kColorBackground),
        foregroundColor: const Color(kColorTextPrimary),
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: const Color(kColorTextPrimary),
        ),
        iconTheme: const IconThemeData(color: Color(kColorTextPrimary)),
      ),
      cardTheme: CardTheme(
        color: const Color(kColorSurface),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
          side: const BorderSide(color: Color(0xFFEAEAEA), width: 1.5),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(kColorPrimary),
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, kMinButtonHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: kPaddingLarge,
            vertical: kPaddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(kColorPrimary),
          side: const BorderSide(color: Color(kColorPrimary), width: 2),
          elevation: 0,
          minimumSize: const Size(double.infinity, kMinButtonHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: kPaddingLarge,
            vertical: kPaddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(kColorPrimary),
          minimumSize: const Size(48, kMinTouchTarget),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(kColorSurfaceAlt),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: const BorderSide(color: Color(kColorPrimary), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: kPaddingMedium,
          vertical: kPaddingMedium,
        ),
        hintStyle: GoogleFonts.nunito(
          color: const Color(kColorTextHint),
          fontWeight: FontWeight.w500,
        ),
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: Color(kColorPrimary),
        inactiveTrackColor: Color(0xFFD8F5C8),
        thumbColor: Color(kColorPrimary),
        overlayColor: Color(0x3358CC02),
        trackHeight: 8,
        thumbShape: RoundSliderThumbShape(
          enabledThumbRadius: 14,
          elevation: 4,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(kColorPrimaryLight),
        selectedColor: const Color(kColorPrimary),
        labelStyle: GoogleFonts.nunito(
          fontWeight: FontWeight.w700,
          color: const Color(kColorPrimary),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusPill),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: const Color(kColorTextHint).withAlpha(51),
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(kColorPrimary),
        contentTextStyle: GoogleFonts.nunito(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color(kColorSurface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(kBorderRadiusXLarge),
          ),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: const Color(kColorSurface),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(kColorSurface),
        selectedItemColor: const Color(kColorPrimary),
        unselectedItemColor: const Color(kColorTextHint),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
        unselectedLabelStyle: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
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
        secondary: Color(kColorSecondary),
        tertiary: Color(kColorAccent),
        surface: Color(kColorDarkSurface),
        error: Color(kColorError),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onTertiary: Colors.white,
        onSurface: Color(kColorDarkTextPrimary),
      ),
      scaffoldBackgroundColor: const Color(kColorDarkBackground),
      textTheme: _buildTextTheme(Brightness.dark),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(kColorDarkBackground),
        foregroundColor: const Color(kColorDarkTextPrimary),
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: const Color(kColorDarkTextPrimary),
        ),
      ),
      cardTheme: CardTheme(
        color: const Color(kColorDarkSurface),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
          side: const BorderSide(color: Color(0xFF3A3B4A), width: 1.5),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(kColorPrimary),
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, kMinButtonHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: kPaddingLarge,
            vertical: kPaddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(kColorPrimary),
          side: const BorderSide(color: Color(kColorPrimary), width: 2),
          elevation: 0,
          minimumSize: const Size(double.infinity, kMinButtonHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: kPaddingLarge,
            vertical: kPaddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(kColorDarkSurfaceAlt),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: const BorderSide(color: Color(kColorPrimary), width: 2),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(kColorDarkSurface),
        selectedItemColor: const Color(kColorPrimary),
        unselectedItemColor: const Color(kColorDarkTextSecondary),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(kColorDarkSurface),
        contentTextStyle: GoogleFonts.nunito(
          color: const Color(kColorDarkTextPrimary),
          fontWeight: FontWeight.w700,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}