import 'package:flutter/material.dart';

// Light Theme Colors (from CSS)
const Color lightText = Color(0xFF090A0B);           // rgb(9, 10, 11)
const Color lightBackground = Color(0xFFFCFDFD);    // rgb(252, 253, 253)
const Color lightPrimary = Color(0xFF4574C4);       // rgb(69, 116, 196)
const Color lightSecondary = Color(0xFF82A9ED);     // rgb(130, 169, 237)
const Color lightAccent = Color(0xFF4588FC);        // rgb(69, 136, 252)
const Color lightSurface = Color(0xFFFFFFFF);       // White for cards

// Dark Theme Colors (from CSS)
const Color darkText = Color(0xFFF4F5F6);           // rgb(244, 245, 246)
const Color darkBackground = Color(0xFF020303);     // rgb(2, 3, 3)
const Color darkPrimary = Color(0xFF3B69BA);        // rgb(59, 105, 186)
const Color darkSecondary = Color(0xFF12397D);      // rgb(18, 57, 125)
const Color darkAccent = Color(0xFF0346BA);         // rgb(3, 70, 186)
const Color darkSurface = Color(0xFF0A0B0C);        // Slightly lighter than background

// Light Theme - Enhanced with better visual hierarchy
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: lightBackground,

  // Color Scheme
  colorScheme: const ColorScheme.light(
    primary: lightPrimary,
    onPrimary: lightBackground,
    primaryContainer: lightSecondary,
    onPrimaryContainer: lightText,
    secondary: lightSecondary,
    onSecondary: lightText,
    secondaryContainer: lightAccent,
    onSecondaryContainer: lightBackground,
    tertiary: lightAccent,
    onTertiary: lightText,
    error: Color(0xFFBA1A1A),
    onError: lightBackground,
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    surface: lightSurface,
    onSurface: lightText,
    surfaceContainerHighest: Color(0xFFF0F2F5),
    onSurfaceVariant: Color(0xFF6B7280),
    outline: Color(0xFFE5E7EB),
    outlineVariant: lightSecondary,
    shadow: Color(0x0A000000),
    scrim: Color(0xFF000000),
    inverseSurface: lightText,
    onInverseSurface: lightSurface,
    inversePrimary: lightAccent,
    surfaceTint: lightPrimary,
  ),

  // Text Theme - Enhanced typography hierarchy
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      color: lightText,
      fontWeight: FontWeight.bold,
      fontSize: 57,
      letterSpacing: -0.5,
    ),
    displayMedium: TextStyle(
      color: lightText,
      fontWeight: FontWeight.bold,
      fontSize: 45,
      letterSpacing: 0,
    ),
    displaySmall: TextStyle(
      color: lightText,
      fontWeight: FontWeight.bold,
      fontSize: 36,
      letterSpacing: 0,
    ),
    headlineLarge: TextStyle(
      color: lightPrimary,
      fontWeight: FontWeight.w700,
      fontSize: 32,
      letterSpacing: 0,
    ),
    headlineMedium: TextStyle(
      color: lightPrimary,
      fontWeight: FontWeight.w700,
      fontSize: 28,
      letterSpacing: 0,
    ),
    headlineSmall: TextStyle(
      color: lightText,
      fontWeight: FontWeight.w700,
      fontSize: 24,
      letterSpacing: 0,
    ),
    titleLarge: TextStyle(
      color: lightText,
      fontWeight: FontWeight.w700,
      fontSize: 22,
      letterSpacing: 0.5,
    ),
    titleMedium: TextStyle(
      color: lightText,
      fontWeight: FontWeight.w600,
      fontSize: 16,
      letterSpacing: 0.15,
    ),
    titleSmall: TextStyle(
      color: lightText,
      fontWeight: FontWeight.w600,
      fontSize: 14,
      letterSpacing: 0.1,
    ),
    bodyLarge: TextStyle(
      color: lightText,
      fontWeight: FontWeight.w500,
      fontSize: 16,
      letterSpacing: 0.5,
    ),
    bodyMedium: TextStyle(
      color: Color(0xFF374151),
      fontWeight: FontWeight.w400,
      fontSize: 14,
      letterSpacing: 0.25,
    ),
    bodySmall: TextStyle(
      color: Color(0xFF6B7280),
      fontWeight: FontWeight.w400,
      fontSize: 12,
      letterSpacing: 0.4,
    ),
    labelLarge: TextStyle(
      color: lightText,
      fontWeight: FontWeight.w700,
      fontSize: 14,
      letterSpacing: 0.1,
    ),
    labelMedium: TextStyle(
      color: lightText,
      fontWeight: FontWeight.w600,
      fontSize: 12,
      letterSpacing: 0.5,
    ),
    labelSmall: TextStyle(
      color: lightText,
      fontWeight: FontWeight.w600,
      fontSize: 11,
      letterSpacing: 0.5,
    ),
  ),

  // App Bar Theme - Refined appearance
  appBarTheme: const AppBarTheme(
    backgroundColor: lightPrimary,
    foregroundColor: lightBackground,
    elevation: 0,
    shadowColor: Color(0x0A000000),
    surfaceTintColor: lightPrimary,
    titleTextStyle: TextStyle(
      color: lightBackground,
      fontSize: 22,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
    ),
  ),

  // Card Theme - Enhanced with subtle depth
  cardTheme: const CardThemeData(
    color: lightSurface,
    elevation: 0,
    shadowColor: Color(0x0A000000),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    margin: EdgeInsets.zero,
  ),

  // Button Themes - Improved visual weight
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: lightPrimary,
      foregroundColor: lightBackground,
      elevation: 2,
      shadowColor: Color(0x2D4574C4),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        letterSpacing: 0.5,
      ),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: lightPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      textStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        letterSpacing: 0.5,
      ),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: lightPrimary,
      side: const BorderSide(color: lightPrimary, width: 2),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        letterSpacing: 0.5,
      ),
    ),
  ),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: lightAccent,
    foregroundColor: lightBackground,
    elevation: 6,
    highlightElevation: 12,
    shape: CircleBorder(),
  ),

  // Input Decoration Theme - Refined borders
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: lightSurface,
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: lightPrimary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Color(0xFFBA1A1A), width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Color(0xFFBA1A1A), width: 2),
    ),
    labelStyle: TextStyle(color: lightText, fontWeight: FontWeight.w500),
    hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
  ),

  // Chip Theme
  chipTheme: ChipThemeData(
    backgroundColor: Color(0xFFF3F4F6),
    selectedColor: Color(0xFFDEE6F8),
    labelPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
    brightness: Brightness.light,
  ),
);

// Dark Theme - Enhanced with better visual hierarchy
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: darkBackground,

  // Color Scheme
  colorScheme: const ColorScheme.dark(
    primary: darkPrimary,
    onPrimary: Color(0xFFF4F5F6),
    primaryContainer: darkSecondary,
    onPrimaryContainer: darkText,
    secondary: darkSecondary,
    onSecondary: darkText,
    secondaryContainer: darkAccent,
    onSecondaryContainer: darkText,
    tertiary: darkAccent,
    onTertiary: darkText,
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: darkSurface,
    onSurface: darkText,
    surfaceContainerHighest: Color(0xFF1A1B1C),
    onSurfaceVariant: Color(0xFFB0B5BE),
    outline: Color(0xFF3A3F47),
    outlineVariant: darkSecondary,
    shadow: Color(0x00000014),
    scrim: Color(0xFF000000),
    inverseSurface: darkText,
    onInverseSurface: darkSurface,
    inversePrimary: darkAccent,
    surfaceTint: darkPrimary,
  ),

  // Text Theme - Enhanced typography hierarchy
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      color: darkText,
      fontWeight: FontWeight.bold,
      fontSize: 57,
      letterSpacing: -0.5,
    ),
    displayMedium: TextStyle(
      color: darkText,
      fontWeight: FontWeight.bold,
      fontSize: 45,
      letterSpacing: 0,
    ),
    displaySmall: TextStyle(
      color: darkText,
      fontWeight: FontWeight.bold,
      fontSize: 36,
      letterSpacing: 0,
    ),
    headlineLarge: TextStyle(
      color: darkAccent,
      fontWeight: FontWeight.w700,
      fontSize: 32,
      letterSpacing: 0,
    ),
    headlineMedium: TextStyle(
      color: darkAccent,
      fontWeight: FontWeight.w700,
      fontSize: 28,
      letterSpacing: 0,
    ),
    headlineSmall: TextStyle(
      color: darkText,
      fontWeight: FontWeight.w700,
      fontSize: 24,
      letterSpacing: 0,
    ),
    titleLarge: TextStyle(
      color: darkText,
      fontWeight: FontWeight.w700,
      fontSize: 22,
      letterSpacing: 0.5,
    ),
    titleMedium: TextStyle(
      color: darkText,
      fontWeight: FontWeight.w600,
      fontSize: 16,
      letterSpacing: 0.15,
    ),
    titleSmall: TextStyle(
      color: darkText,
      fontWeight: FontWeight.w600,
      fontSize: 14,
      letterSpacing: 0.1,
    ),
    bodyLarge: TextStyle(
      color: darkText,
      fontWeight: FontWeight.w500,
      fontSize: 16,
      letterSpacing: 0.5,
    ),
    bodyMedium: TextStyle(
      color: Color(0xFFD1D5DB),
      fontWeight: FontWeight.w400,
      fontSize: 14,
      letterSpacing: 0.25,
    ),
    bodySmall: TextStyle(
      color: Color(0xFF9CA3AF),
      fontWeight: FontWeight.w400,
      fontSize: 12,
      letterSpacing: 0.4,
    ),
    labelLarge: TextStyle(
      color: darkText,
      fontWeight: FontWeight.w700,
      fontSize: 14,
      letterSpacing: 0.1,
    ),
    labelMedium: TextStyle(
      color: darkText,
      fontWeight: FontWeight.w600,
      fontSize: 12,
      letterSpacing: 0.5,
    ),
    labelSmall: TextStyle(
      color: darkText,
      fontWeight: FontWeight.w600,
      fontSize: 11,
      letterSpacing: 0.5,
    ),
  ),

  // App Bar Theme - Refined appearance
  appBarTheme: const AppBarTheme(
    backgroundColor: darkPrimary,
    foregroundColor: darkText,
    elevation: 0,
    shadowColor: Color(0x0A000000),
    surfaceTintColor: darkPrimary,
    titleTextStyle: TextStyle(
      color: darkText,
      fontSize: 22,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
    ),
  ),

  // Card Theme - Enhanced with subtle depth
  cardTheme: const CardThemeData(
    color: darkSurface,
    elevation: 0,
    shadowColor: Color(0x0A000000),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    margin: EdgeInsets.zero,
  ),

  // Button Themes - Improved visual weight
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: darkPrimary,
      foregroundColor: darkText,
      elevation: 2,
      shadowColor: Color(0x2D3B69BA),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        letterSpacing: 0.5,
      ),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: darkAccent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      textStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        letterSpacing: 0.5,
      ),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: darkPrimary,
      side: const BorderSide(color: darkPrimary, width: 2),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        letterSpacing: 0.5,
      ),
    ),
  ),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: darkAccent,
    foregroundColor: darkText,
    elevation: 6,
    highlightElevation: 12,
    shape: CircleBorder(),
  ),

  // Input Decoration Theme - Refined borders
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: darkSurface,
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Color(0xFF3A3F47), width: 1.5),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Color(0xFF3A3F47), width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: darkAccent, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Color(0xFFFFB4AB), width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Color(0xFFFFB4AB), width: 2),
    ),
    labelStyle: TextStyle(color: darkText, fontWeight: FontWeight.w500),
    hintStyle: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
  ),

  // Chip Theme
  chipTheme: ChipThemeData(
    backgroundColor: Color(0xFF1A1B1C),
    selectedColor: Color(0xFF2D3A4F),
    labelPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
    brightness: Brightness.dark,
  ),
);