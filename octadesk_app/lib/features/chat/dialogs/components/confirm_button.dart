import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';

class ConfirmButton extends StatelessWidget {
  final void Function() onPressed;
  final String icon;
  const ConfirmButton({required this.onPressed, required this.icon, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      width: AppSizes.s13,
      height: AppSizes.s13,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(AppSizes.s07)),
        border: Border.all(color: Colors.white),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Center(child: Image.asset(icon, width: AppSizes.s07)),
        ),
      ),
    );
  }
}
