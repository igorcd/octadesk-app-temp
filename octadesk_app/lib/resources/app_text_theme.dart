import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';

class AppTextTheme {
  static TextTheme light() {
    return TextTheme(
      // Display smaill
      displaySmall: TextStyle(
        fontWeight: FontWeight.bold,
        letterSpacing: -1,
        height: 1.1,
        fontSize: AppSizes.s05,
        color: AppColors.info.shade500,
      ),

      // Headline
      headlineLarge: TextStyle(
        fontFamily: "Poppins",
        fontWeight: FontWeight.w600,
        letterSpacing: -1,
        height: 1.1,
        fontSize: AppSizes.s06,
        color: AppColors.info.shade800,
      ),
      headlineSmall: TextStyle(
        fontFamily: "Poppins",
        fontWeight: FontWeight.w600,
        color: AppColors.info.shade500,
        fontSize: AppSizes.s05_5,
      ),

      // Body
      bodyMedium: TextStyle(
        fontSize: AppSizes.s04,
        color: AppColors.info.shade800,
      ),

      // Body
      bodyLarge: TextStyle(
        fontFamily: "Poppins",
        fontSize: AppSizes.s04,
        color: AppColors.info.shade500,
        fontWeight: FontWeight.w600,
      ),
      bodySmall: TextStyle(
        fontSize: AppSizes.s04,
        color: AppColors.info.shade500,
      ),

      // Title
      titleLarge: TextStyle(
        fontSize: AppSizes.s04,
        fontFamily: "Poppins",
        color: AppColors.info.shade800,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        fontSize: AppSizes.s04,
        fontFamily: "Poppins",
        color: AppColors.info.shade500,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: TextStyle(
        color: AppColors.info.shade500,
        fontSize: AppSizes.s03,
      ),

      // Label
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

  static TextTheme dark() {
    return TextTheme(
      // Display smaill
      displaySmall: TextStyle(
        fontWeight: FontWeight.bold,
        letterSpacing: -1,
        height: 1.1,
        fontSize: AppSizes.s05,
        color: AppColors.info.shade300,
      ),

      // Headline
      headlineLarge: const TextStyle(
        fontFamily: "Poppins",
        fontWeight: FontWeight.w600,
        letterSpacing: -1,
        height: 1.1,
        fontSize: AppSizes.s06,
        color: Colors.white,
      ),
      headlineSmall: TextStyle(
        fontFamily: "Poppins",
        fontWeight: FontWeight.w600,
        color: AppColors.info.shade300,
        fontSize: AppSizes.s05_5,
      ),

      // Body

      bodyLarge: TextStyle(
        fontFamily: "Poppins",
        fontSize: AppSizes.s04,
        color: AppColors.info.shade300,
      ),
      bodyMedium: const TextStyle(
        fontSize: AppSizes.s04,
        color: Colors.white,
      ),
      bodySmall: TextStyle(
        fontSize: AppSizes.s04,
        color: AppColors.info.shade300,
      ),

      // Title
      titleLarge: TextStyle(
        fontSize: AppSizes.s04,
        fontFamily: "Poppins",
        color: AppColors.info.shade100,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        fontSize: AppSizes.s04,
        fontFamily: "Poppins",
        color: AppColors.info.shade300,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: const TextStyle(
        color: Colors.white60,
        fontSize: AppSizes.s03,
      ),

      // Label
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
      //
      // Falta correção
      //

      // displayMedium: const TextStyle(
      //   fontFamily: "Poppins",
      //   fontWeight: FontWeight.w600,
      //   letterSpacing: -1,
      //   height: 1.2,
      //   fontSize: 22,
      //   color: Colors.white,
      // ),
      // displaySmall: const TextStyle(
      //   fontFamily: "Poppins",
      //   fontWeight: FontWeight.w600,
      //   letterSpacing: -1,
      //   height: 1.1,
      //   fontSize: AppSizes.s04_5,
      //   color: Colors.white,
      // ),

      // // Headline Small
      // headlineLarge: const TextStyle(
      //   fontFamily: "Poppins",
      //   fontWeight: FontWeight.w600,
      //   letterSpacing: -1,
      //   height: 1.1,
      //   fontSize: AppSizes.s06,
      //   color: Colors.white,
      // ),
      // headlineMedium: const TextStyle(
      //   fontFamily: "Poppins",
      //   fontWeight: FontWeight.w500,
      //   color: Colors.white,
      //   fontSize: AppSizes.s06,
      // ),

      // // Label Medium
      // labelMedium: const TextStyle(
      //   fontSize: AppSizes.s03,
      //   color: Colors.white,
      //   fontWeight: FontWeight.w500,
      // ),

      // bodyLarge: const TextStyle(
      //   fontFamily: "Poppins",
      //   fontWeight: FontWeight.w600,
      //   fontSize: AppSizes.s04,
      //   color: Colors.white,
      // ),

      // bodySmall: const TextStyle(
      //   fontSize: AppSizes.s03_5,
      //   color: Colors.white60,
      // ),
    );
  }
}
