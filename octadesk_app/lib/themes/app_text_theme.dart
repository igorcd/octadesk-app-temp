import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';

class AppTextTheme {
  static TextTheme light() {
    return TextTheme(
      displayMedium: TextStyle(
        fontFamily: "Poppins",
        fontWeight: FontWeight.w600,
        letterSpacing: -1,
        height: 1.2,
        fontSize: 22,
        color: AppColors.info.shade800,
      ),
      displaySmall: TextStyle(
        fontFamily: "Poppins",
        fontWeight: FontWeight.w600,
        letterSpacing: -1,
        height: 1.1,
        fontSize: AppSizes.s04_5,
        color: AppColors.info.shade800,
      ),

      // Headline Small
      headlineLarge: TextStyle(
        fontFamily: "Poppins",
        fontWeight: FontWeight.w600,
        letterSpacing: -1,
        height: 1.1,
        fontSize: AppSizes.s06,
        color: AppColors.info.shade800,
      ),
      headlineMedium: TextStyle(
        fontFamily: "Poppins",
        fontWeight: FontWeight.w500,
        color: AppColors.info.shade800,
        fontSize: AppSizes.s06,
      ),
      headlineSmall: TextStyle(
        fontFamily: "Poppins",
        fontWeight: FontWeight.bold,
        color: AppColors.info.shade800,
        fontSize: AppSizes.s04,
      ),

      titleMedium: TextStyle(
        fontFamily: "Poppins",
        fontWeight: FontWeight.bold,
        fontSize: AppSizes.s03_5,
        color: AppColors.info.shade800,
      ),
      titleSmall: TextStyle(
        color: AppColors.info.shade600,
        fontSize: AppSizes.s03,
      ),

      // Label Medium
      labelMedium: TextStyle(
        fontSize: AppSizes.s03,
        color: AppColors.info.shade800,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        fontSize: AppSizes.s03,
        color: AppColors.info.shade800,
        fontWeight: FontWeight.normal,
        letterSpacing: 0,
      ),
      bodyLarge: TextStyle(
        fontFamily: "Poppins",
        fontWeight: FontWeight.w600,
        fontSize: AppSizes.s04,
        color: AppColors.info.shade800,
      ),
      bodyMedium: TextStyle(
        fontSize: AppSizes.s04,
        color: AppColors.info.shade800,
      ),
      bodySmall: TextStyle(
        fontSize: AppSizes.s03_5,
        color: AppColors.info.shade600,
      ),
    );
  }

  static TextTheme dark() {
    return const TextTheme(
      displayMedium: TextStyle(
        fontFamily: "Poppins",
        fontWeight: FontWeight.w600,
        letterSpacing: -1,
        height: 1.2,
        fontSize: 22,
        color: Colors.white,
      ),
      displaySmall: TextStyle(
        fontFamily: "Poppins",
        fontWeight: FontWeight.w600,
        letterSpacing: -1,
        height: 1.1,
        fontSize: AppSizes.s04_5,
        color: Colors.white,
      ),

      // Headline Small
      headlineLarge: TextStyle(
        fontFamily: "Poppins",
        fontWeight: FontWeight.w600,
        letterSpacing: -1,
        height: 1.1,
        fontSize: AppSizes.s06,
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        fontFamily: "Poppins",
        fontWeight: FontWeight.w500,
        color: Colors.white,
        fontSize: AppSizes.s06,
      ),
      headlineSmall: TextStyle(
        fontFamily: "Poppins",
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: AppSizes.s04,
      ),

      titleMedium: TextStyle(
        fontFamily: "Poppins",
        fontWeight: FontWeight.bold,
        fontSize: AppSizes.s03_5,
        color: Colors.white,
      ),
      titleSmall: TextStyle(
        color: Colors.white60,
        fontSize: AppSizes.s03,
      ),

      // Label Medium
      labelMedium: TextStyle(
        fontSize: AppSizes.s03,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        fontSize: AppSizes.s03,
        color: Colors.white,
        fontWeight: FontWeight.normal,
        letterSpacing: 0,
      ),
      bodyLarge: TextStyle(
        fontFamily: "Poppins",
        fontWeight: FontWeight.w600,
        fontSize: AppSizes.s04,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: AppSizes.s04,
        color: Colors.white,
      ),
      bodySmall: TextStyle(
        fontSize: AppSizes.s03_5,
        color: Colors.white60,
      ),
    );
  }
}
