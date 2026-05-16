import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// App theme configuration for 清流
class AppTheme {
  AppTheme._();

  /// Light theme
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: Color(kColorPrimary),
      secondary: Color(kColorSecondary),
      tertiary: Color(kColorAccent),
      surface: Color(kColorSurface),
      error: Color(kColorError),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onTertiary: Colors.white,
      onSurface: Color(kColorTextPrimary),
    ),
    scaffoldBackgroundColor: Color(kColorBackground),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(kColorSurface),
      foregroundColor: Color(kColorTextPrimary),
      elevation: 0,
      centerTitle: true,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(kColorSurface),
      selectedItemColor: Color(kColorPrimary),
      unselectedItemColor: Color(kColorTextHint),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    cardTheme: CardTheme(
      color: Color(kColorSurface),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(kColorPrimary),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: kPaddingLarge,
          vertical: kPaddingMedium,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Color(kColorPrimary),
        side: const BorderSide(color: Color(kColorPrimary)),
        padding: const EdgeInsets.symmetric(
          horizontal: kPaddingLarge,
          vertical: kPaddingMedium,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Color(kColorSecondary),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(kColorBackground),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kBorderRadiusSmall),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kBorderRadiusSmall),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kBorderRadiusSmall),
        borderSide: const BorderSide(color: Color(kColorSecondary), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: kPaddingMedium,
        vertical: kPaddingSmall,
      ),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: Color(kColorSecondary),
      inactiveTrackColor: Color(kColorSecondary).withAlpha(77),
      thumbColor: Color(kColorSecondary),
      overlayColor: Color(kColorSecondary).withAlpha(51),
      trackHeight: 6,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: Color(kColorPrimary),
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Color(kColorTextPrimary),
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Color(kColorTextPrimary),
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(kColorTextPrimary),
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(kColorTextPrimary),
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Color(kColorTextPrimary),
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Color(kColorTextSecondary),
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(kColorTextPrimary),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE0E0E0),
      thickness: 1,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Color(kColorPrimary),
      contentTextStyle: const TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadiusSmall),
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );

  /// Dark theme
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: Color(kColorSecondary),
      secondary: Color(kColorAccent),
      tertiary: Color(kColorPrimary),
      surface: const Color(0xFF1E1E1E),
      error: Color(kColorError),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onTertiary: Colors.white,
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      selectedItemColor: Color(kColorSecondary),
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF2D2D2D),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(kColorSecondary),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: kPaddingLarge,
          vertical: kPaddingMedium,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.white70,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.white60,
      ),
    ),
  );
}