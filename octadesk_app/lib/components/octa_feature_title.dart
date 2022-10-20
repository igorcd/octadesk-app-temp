import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/app_icons.dart';
import 'package:octadesk_app/resources/app_sizes.dart';

class OctaFeatureTitle extends StatelessWidget {
  final String text;
  final void Function() onTap;
  const OctaFeatureTitle({required this.text, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: AppSizes.s04),
      child: Material(
        borderRadius: BorderRadius.circular(AppSizes.s02),
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSizes.s01),
            child: Row(
              children: [
                // Botão
                Text(
                  text,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: AppSizes.s05_5,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onBackground,
                  ),
                ),
                const SizedBox(width: AppSizes.s01),
                Image.asset(
                  AppIcons.angleDown,
                  width: AppSizes.s05,
                  color: colorScheme.onBackground,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
