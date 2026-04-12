import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Цветовая схема приложения
/// Все основные цвета задаются здесь для обеспечения консистентности
class AppColors {
  // Основные цвета (светлая тема)
  static const Color primary = Color(0xFF2563EB);      // Синий основной
  static const Color primaryDark = Color(0xFF60A5FA);  // Мягкий синий основной (темная)
  static const Color secondary = Color(0xFFECECF0);    // Светло-серый вторичный

  // Семантические цвета
  static const Color error = Color(0xFFD4183D);        // Красный для ошибок
  static const Color success = Color(0xFF388E3C);      // Зеленый для успеха
  static const Color warning = Color(0xFFF57C00);      // Оранжевый для предупреждений
  static const Color info = Color(0xFF1976D2);         // Синий для информации

  // Нейтральные цвета (светлая тема)
  static const Color surface = Color(0xFFFFFFFF);      // Поверхность
  static const Color background = Color(0xFFF9FAFB);   // Фон

  // Нейтральные цвета (темная тема)
  static const Color surfaceDark = Color(0xFF334155);  // Поверхность (темная)
  static const Color backgroundDark = Color(0xFF1E293B); // Фон (темная)

  // Текстовые цвета (светлая тема)
  static const Color onPrimary = Color(0xFFFFFFFF);    // Текст на основном цвете
  static const Color onSecondary = Color(0xFF030213);  // Текст на вторичном цвете
  static const Color onSurface = Color(0xFF111827);    // Текст на поверхности
  static const Color onSurfaceVariant = Color(0xFF6B7280); // Вариант текста на поверхности

  // Текстовые цвета (темная тема)
  static const Color onPrimaryDark = Color(0xFFFFFFFF); // Текст на основном (темная)
  static const Color onSecondaryDark = Color(0xFFFCFCFC); // Текст на вторичном (темная)
  static const Color onSurfaceDark = Color(0xFFE2E8F0); // Текст на поверхности (темная)

  // Обводка и разделители
  static const Color outline = Color(0x1A000000);      // Обводка (светлая)
  static const Color outlineDark = Color(0xFF444444);  // Обводка (темная)

  // Дополнительные цвета
  static const Color muted = Color(0xFFECECF0);        // Приглушенный (светлая)
  static const Color mutedDark = Color(0xFF444444);    // Приглушенный (темная)
  static const Color accent = Color(0xFFE9EBEF);       // Акцент (светлая)
  static const Color accentDark = Color(0xFF444444);   // Акцент (темная)
  static const Color hint = Color(0xFF6B7280);         // Подсказки
  static const Color shadow = Color(0xFF000000);       // Тени

  // Статусные цвета
  static const Color statusResolved = Color(0xFF10B981); // green
  static const Color statusInProgress = Color(0xFF60A5FA); // soft blue
  static const Color statusUnderReview = Color(0xFFF59E0B); // amber
  static const Color statusRejected = Color(0xFFEF4444); // red
}

/// Текстовые стили приложения
/// Все стили типографики определены здесь для консистентности
class AppTextStyles {
  // Заголовки
  static TextStyle h1 = GoogleFonts.roboto(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: AppColors.onSurface,
  );

  static TextStyle h2 = GoogleFonts.roboto(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: AppColors.onSurface,
  );

  // Основной текст
  static TextStyle body = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.onSurface,
  );

  static TextStyle bodyBold = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: AppColors.onSurface,
  );

  // Вспомогательный текст
  static TextStyle caption = GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.onSurfaceVariant,
  );

  static TextStyle captionBold = GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.onSurfaceVariant,
  );

  // Кнопки
  static TextStyle button = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.2,
    color: AppColors.onPrimary,
  );

  static TextStyle buttonSecondary = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.2,
    color: AppColors.primary,
  );

  // Методы для создания стилей с разными цветами
  static TextStyle h1WithColor(Color color) => h1.copyWith(color: color);
  static TextStyle h2WithColor(Color color) => h2.copyWith(color: color);
  static TextStyle bodyWithColor(Color color) => body.copyWith(color: color);
  static TextStyle captionWithColor(Color color) => caption.copyWith(color: color);
}

/// Тема приложения
/// Объединяет цвета, типографику и компоненты в единую тему
class AppTheme {
  /// Светлая тема
  static ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      error: AppColors.error,
      onError: Colors.white,
      outline: AppColors.outline,
    ),
    textTheme: TextTheme(
      headlineLarge: AppTextStyles.h1,
      headlineMedium: AppTextStyles.h2,
      bodyLarge: AppTextStyles.body,
      bodyMedium: AppTextStyles.body,
      bodySmall: AppTextStyles.caption,
      labelLarge: AppTextStyles.button,
    ).apply(
      fontFamily: GoogleFonts.roboto().fontFamily,
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      shadowColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
        shadowColor: AppColors.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        minimumSize: const Size(double.infinity, 56),
        textStyle: AppTextStyles.button,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: AppTextStyles.body.copyWith(color: AppColors.hint),
      labelStyle: AppTextStyles.body,
    ),
  );

  /// Темная тема
  static ThemeData dark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primaryDark,
      onPrimary: AppColors.onPrimaryDark,
      secondary: AppColors.mutedDark,
      onSecondary: AppColors.onSecondaryDark,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.onSurfaceDark,
      error: AppColors.error,
      onError: Colors.white,
      outline: AppColors.outlineDark,
    ),
    textTheme: TextTheme(
      headlineLarge: AppTextStyles.h1.copyWith(color: AppColors.onSurfaceDark),
      headlineMedium: AppTextStyles.h2.copyWith(color: AppColors.onSurfaceDark),
      bodyLarge: AppTextStyles.body.copyWith(color: AppColors.onSurfaceDark),
      bodyMedium: AppTextStyles.body.copyWith(color: AppColors.onSurfaceDark),
      bodySmall: AppTextStyles.caption.copyWith(color: AppColors.onSurfaceVariant),
      labelLarge: AppTextStyles.button,
    ).apply(
      fontFamily: GoogleFonts.roboto().fontFamily,
    ),
    cardTheme: CardThemeData(
      color: AppColors.surfaceDark,
      shadowColor: AppColors.shadow.withValues(alpha: 0.12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.onSurfaceDark,
        foregroundColor: AppColors.onPrimaryDark,
        elevation: 0,
        shadowColor: AppColors.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        minimumSize: const Size(double.infinity, 56),
        textStyle: AppTextStyles.button,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: AppTextStyles.body.copyWith(color: AppColors.hint),
      labelStyle: AppTextStyles.body.copyWith(color: AppColors.onPrimary),
    ),
  );
}