import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';

class AppTextTheme {
  static TextTheme get light {
    return TextTheme(
      // Display smaill
      displaySmall: TextStyle(
        fontWeight: FontWeight.w600,
        letterSpacing: -1,
        height: 1.1,
        fontSize: AppSizes.s05,
        color: AppColors.info.shade900,
      ),

      // Headline
      headlineLarge: TextStyle(
        fontWeight: FontWeight.w600,
        letterSpacing: -1,
        height: 1.3,
        fontSize: AppSizes.s06,
        color: AppColors.info.shade800,
      ),
      headlineSmall: TextStyle(
        fontWeight: FontWeight.w600,
        color: AppColors.info.shade500,
        fontSize: AppSizes.s05_5,
      ),

      // Body
      // Body
      bodyLarge: TextStyle(
        fontSize: AppSizes.s04,
        color: AppColors.info.shade900,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: TextStyle(
        fontSize: AppSizes.s04,
        color: AppColors.info.shade800,
      ),

      bodySmall: TextStyle(
        fontSize: AppSizes.s03_5,
        color: AppColors.info.shade500,
      ),

      // Title
      titleLarge: TextStyle(
        fontSize: AppSizes.s04,
        color: AppColors.info.shade800,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        fontSize: AppSizes.s04,
        color: AppColors.info.shade500,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: TextStyle(
        color: AppColors.info.shade500,
        fontSize: AppSizes.s03,
      ),

      // Label
      labelLarge: TextStyle(
        fontSize: AppSizes.s03_5,
        color: AppColors.info.shade900,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      ),
      labelMedium: TextStyle(
        fontSize: AppSizes.s03,
        color: AppColors.info.shade400,
        fontWeight: FontWeight.normal,
        letterSpacing: 0,
      ),
      labelSmall: TextStyle(
        fontSize: AppSizes.s03,
        color: AppColors.info.shade800,
        fontWeight: FontWeight.normal,
        letterSpacing: 0,
      ),
    );
  }

  static TextTheme get dark {
    return TextTheme(
      // Display smaill
      displaySmall: TextStyle(
        fontWeight: FontWeight.w600,
        letterSpacing: -1,
        height: 1.1,
        fontSize: AppSizes.s05,
        color: AppColors.info.shade100,
      ),

      // Headline
      headlineLarge: const TextStyle(
        fontWeight: FontWeight.w600,
        letterSpacing: -1,
        height: 1.3,
        fontSize: AppSizes.s06,
        color: Colors.white,
      ),
      headlineSmall: TextStyle(
        fontWeight: FontWeight.w600,
        color: AppColors.info.shade300,
        fontSize: AppSizes.s05_5,
      ),

      // Body
      // Body
      bodyLarge: TextStyle(
        fontSize: AppSizes.s04,
        color: AppColors.info.shade100,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: const TextStyle(
        fontSize: AppSizes.s04,
        color: Colors.white,
      ),

      bodySmall: TextStyle(
        fontSize: AppSizes.s03_5,
        color: AppColors.info.shade300,
      ),

      // Title
      titleLarge: TextStyle(
        fontSize: AppSizes.s04,
        color: AppColors.info.shade100,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        fontSize: AppSizes.s04,
        color: AppColors.info.shade300,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: TextStyle(
        color: AppColors.info.shade300,
        fontSize: AppSizes.s03,
      ),

      // Label
      labelLarge: TextStyle(
        fontSize: AppSizes.s03_5,
        color: AppColors.indigo.shade100,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      ),
      labelMedium: TextStyle(
        fontSize: AppSizes.s03,
        color: AppColors.info.shade300,
        fontWeight: FontWeight.normal,
        letterSpacing: 0,
      ),
      labelSmall: const TextStyle(
        fontSize: AppSizes.s03,
        color: Colors.white,
        fontWeight: FontWeight.normal,
        letterSpacing: 0,
      ),
    );
  }
}
