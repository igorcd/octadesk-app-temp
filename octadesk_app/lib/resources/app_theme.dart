import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/app_text_theme.dart';
import 'package:octadesk_app/resources/index.dart';

class AppTheme {
  // Light ======
  static ThemeData light(MaterialColor primarySwatch) {
    return ThemeData(
      fontFamily: "NotoSans",
      dividerTheme: DividerThemeData(
        space: 1,
        thickness: 1,
        color: AppColors.info.shade200,
      ),
      sliderTheme: SliderThemeData(
        thumbColor: primarySwatch,
        overlayShape: SliderComponentShape.noOverlay,
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 8,
        ),
      ),
      colorScheme: const ColorScheme.light().copyWith(
        onSecondary: AppColors.info.shade400,

        // Background
        background: AppColors.info.shade100,
        onBackground: AppColors.info.shade500,

        // Surface
        surface: Colors.white,
        onSurface: AppColors.info.shade800,

        // Surface variante
        surfaceVariant: AppColors.info.shade200,
        onSurfaceVariant: AppColors.info.shade700,

        // Primario
        primary: primarySwatch.shade400,
        onPrimary: Colors.white,

        // Primary container
        primaryContainer: primarySwatch.shade100,
        onPrimaryContainer: primarySwatch.shade700,

        // Inverse primary
        inversePrimary: primarySwatch.shade800,

        // Outlines
        outline: AppColors.info.shade200,

        // Tertiary
        tertiary: AppColors.amber,
        tertiaryContainer: AppColors.amber.shade100,
      ),
      textTheme: AppTextTheme.light(),
    );
  }

  // Dark

  static ThemeData dark(MaterialColor primarySwatch) {
    return ThemeData(
      dividerTheme: DividerThemeData(
        space: 1,
        thickness: 1,
        color: AppColors.info.shade600,
      ),
      colorScheme: const ColorScheme.dark().copyWith(
        // Secondary
        onSecondary: AppColors.info.shade300,

        // Background
        background: AppColors.info.shade900,
        onBackground: AppColors.info.shade400,

        // Surface
        surface: AppColors.info.shade800,
        onSurface: AppColors.info.shade100,

        // Surface variante
        surfaceVariant: AppColors.info.shade700,
        onSurfaceVariant: AppColors.info.shade100,

        // Primary
        primary: primarySwatch.shade500,
        onPrimary: Colors.white,

        // Primary container
        primaryContainer: primarySwatch.shade700,
        onPrimaryContainer: primarySwatch.shade300,

        // Inverse primary
        inversePrimary: primarySwatch.shade100,

        // Outline
        outline: AppColors.info.shade600,

        // Tertiary
        tertiary: AppColors.amber,
        tertiaryContainer: AppColors.amber.shade800,
      ),
      textTheme: AppTextTheme.dark(),
    );
  }
}
