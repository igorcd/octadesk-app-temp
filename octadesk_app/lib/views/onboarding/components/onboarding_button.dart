import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';

class OnboardingButton extends StatelessWidget {
  final void Function() onPressed;
  final bool secondary;
  final String text;

  const OnboardingButton({required this.onPressed, required this.text, this.secondary = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var is2xsScreenHelper = MediaQuery.of(context).size.height <= 640;

    return Expanded(
      child: Opacity(
        opacity: secondary ? .5 : 1,
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.onSurface,
            padding: EdgeInsets.all(is2xsScreenHelper ? AppSizes.s02 : AppSizes.s05),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: "NotoSans",
            ),
          ),
        ),
      ),
    );
  }
}
