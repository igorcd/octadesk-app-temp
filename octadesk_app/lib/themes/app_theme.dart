import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_app/themes/app_text_theme.dart';

class AppTheme {
  // Light ======
  static ThemeData light(MaterialColor primarySwatch) {
    return ThemeData(
      fontFamily: "NotoSans",
      colorScheme: const ColorScheme.light().copyWith(
        background: AppColors.info.shade100,
        primary: primarySwatch.shade500,
        onPrimaryContainer: primarySwatch.shade800,
      ),
      textTheme: AppTextTheme.light(),
    );
  }

  // Dark

  static ThemeData dark(MaterialColor primarySwatch) {
    return ThemeData(
      colorScheme: const ColorScheme.dark().copyWith(
        background: AppColors.info.shade800,
        primary: primarySwatch.shade400,
        onPrimaryContainer: primarySwatch.shade100,
      ),
      textTheme: AppTextTheme.dark(),
    );
  }
}
