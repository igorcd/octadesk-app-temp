import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';

class OctaIconButton extends StatelessWidget {
  final void Function() onPressed;
  final double size;
  final double iconSize;
  final String icon;

  const OctaIconButton({
    this.size = AppSizes.s12,
    this.iconSize = AppSizes.s08,
    required this.onPressed,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(999))),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Center(
            child: Image.asset(
              icon,
              fit: BoxFit.contain,
              height: iconSize,
              width: iconSize,
            ),
          ),
        ),
      ),
    );
  }
}
