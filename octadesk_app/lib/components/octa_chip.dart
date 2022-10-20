import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/app_sizes.dart';

class OctaChip extends StatelessWidget {
  final MaterialColor color;
  final String text;
  const OctaChip({required this.color, required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    var darkModeActive = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.s02),
      decoration: BoxDecoration(
        color: darkModeActive ? color.shade700 : color.shade200,
        borderRadius: BorderRadius.circular(AppSizes.s01),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "Poppins",
          color: darkModeActive ? color.shade200 : color.shade700,
          fontSize: AppSizes.s03,
        ),
      ),
    );
  }
}
