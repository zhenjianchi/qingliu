import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
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
    scaffoldBackgroundColor: Color(kColorBackground),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Color(kColorTextPrimary),
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(kColorTextPrimary),
      ),
    ),
    cardTheme: CardTheme(
      color: Color(kColorSurface),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadiusLarge),
      ),
      margin: EdgeInsets.zero,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(kColorPrimary),
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(double.infinity, kMinButtonHeight),
        padding: const EdgeInsets.symmetric(horizontal: kPaddingLarge),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Color(kColorPrimary),
        side: BorderSide(color: Color(kColorPrimary), width: 1.5),
        elevation: 0,
        minimumSize: const Size(double.infinity, kMinButtonHeight),
        padding: const EdgeInsets.symmetric(horizontal: kPaddingLarge),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Color(kColorPrimary),
        minimumSize: const Size(48, kMinTouchTarget),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(kColorSurfaceAlt),
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
        borderSide: BorderSide(color: Color(kColorPrimary), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: kPaddingMedium,
        vertical: kPaddingMedium,
      ),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: Color(kColorPrimary),
      inactiveTrackColor: Color(kColorPrimary).withAlpha(51),
      thumbColor: Colors.white,
      overlayColor: Color(kColorPrimary).withAlpha(38),
      trackHeight: 6,
      thumbShape: const RoundSliderThumbShape(
        enabledThumbRadius: 12,
        elevation: 4,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Color(kColorPrimary).withAlpha(26),
      selectedColor: Color(kColorPrimary),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 56,
        fontWeight: FontWeight.w200,
        color: Color(kColorPrimary),
        letterSpacing: -1.5,
      ),
      displayMedium: TextStyle(
        fontSize: 44,
        fontWeight: FontWeight.w200,
        color: Color(kColorTextPrimary),
        letterSpacing: -0.5,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
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
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Color(kColorTextSecondary),
        height: 1.5,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(kColorTextPrimary),
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: Color(kColorTextHint),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: Color(kColorTextHint).withAlpha(51),
      thickness: 1,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Color(kColorPrimary),
      contentTextStyle: const TextStyle(color: Colors.white),
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
      backgroundColor: Color(kColorSurface),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadiusLarge),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(kColorSurface),
      selectedItemColor: Color(kColorPrimary),
      unselectedItemColor: Color(kColorTextHint),
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
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
    scaffoldBackgroundColor: Color(kColorDarkBackground),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Color(kColorDarkTextPrimary),
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(kColorDarkTextPrimary),
      ),
    ),
    cardTheme: CardTheme(
      color: Color(kColorDarkSurface),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadiusLarge),
      ),
      margin: EdgeInsets.zero,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(kColorPrimary),
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(double.infinity, kMinButtonHeight),
        padding: const EdgeInsets.symmetric(horizontal: kPaddingLarge),
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
        side: BorderSide(color: Color(kColorPrimary), width: 1.5),
        elevation: 0,
        minimumSize: const Size(double.infinity, kMinButtonHeight),
        padding: const EdgeInsets.symmetric(horizontal: kPaddingLarge),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(kColorDarkSurfaceAlt),
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
        borderSide: BorderSide(color: Color(kColorPrimary), width: 2),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 56,
        fontWeight: FontWeight.w200,
        color: Color(kColorPrimary),
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: Color(kColorDarkTextPrimary),
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(kColorDarkTextPrimary),
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Color(kColorDarkTextPrimary),
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Color(kColorDarkTextSecondary),
        height: 1.5,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(kColorDarkSurface),
      selectedItemColor: Color(kColorPrimary),
      unselectedItemColor: Color(kColorDarkTextSecondary),
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Color(kColorDarkSurface),
      contentTextStyle: const TextStyle(color: Color(kColorDarkTextPrimary)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}