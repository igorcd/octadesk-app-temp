import 'package:flutter/material.dart';

import '../resources/index.dart';

class OctaTextButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  final Color color;
  final double fontSize;
  final String fontFamily;
  final FontWeight fontWeight;
  final EdgeInsets padding;

  const OctaTextButton({
    required this.onPressed,
    required this.text,
    this.color = AppColors.blue600,
    this.fontSize = AppSizes.s03,
    this.fontFamily = "NotoSans",
    this.fontWeight = FontWeight.bold,
    this.padding = EdgeInsets.zero,
    Key? key,
  }) : super(key: key);

  factory OctaTextButton.primary({required void Function() onPressed, required String text}) {
    return OctaTextButton(
      onPressed: onPressed,
      text: text,
      color: AppColors.blue400,
      fontFamily: "Poppins",
      fontSize: AppSizes.s04_5,
      fontWeight: FontWeight.w600,
      padding: const EdgeInsets.all(AppSizes.s04),
    );
  }

  factory OctaTextButton.secondary({required void Function() onPressed, required String text}) {
    return OctaTextButton(
      onPressed: onPressed,
      text: text,
      color: AppColors.gray300,
      fontSize: AppSizes.s03_5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: padding,
          child: Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: fontWeight,
              fontFamily: fontFamily,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}
