import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';

class OctaAnimatedIconButton extends StatelessWidget {
  final void Function() onPressed;
  final double size;
  final double iconSize;
  final String icon;

  const OctaAnimatedIconButton({
    this.size = AppSizes.s12,
    this.iconSize = AppSizes.s08,
    required this.onPressed,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(size))),
      clipBehavior: Clip.hardEdge,

      // Botão de play e pause
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: AnimatedSwitcher(
            transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
            duration: const Duration(milliseconds: 150),
            child: Image.asset(
              icon,
              width: iconSize,
              key: ValueKey(icon),
            ),
          ),
        ),
      ),
    );
  }
}
