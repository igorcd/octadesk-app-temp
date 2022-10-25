import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/resources/index.dart';

class OctaListButton extends StatelessWidget {
  final String text;
  final void Function() onTap;
  const OctaListButton({required this.onTap, required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: AppSizes.s12,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Expanded(
                child: OctaText.bodyLarge(text),
              ),
              Image.asset(
                AppIcons.angleRight,
                color: colorScheme.onBackground,
                width: AppSizes.s08,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
