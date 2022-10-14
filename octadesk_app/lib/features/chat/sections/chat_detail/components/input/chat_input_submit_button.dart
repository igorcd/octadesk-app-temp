import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/app_icons.dart';
import 'package:octadesk_app/resources/app_sizes.dart';

class ChatInputSubmitButton extends StatelessWidget {
  final bool internalMessageActive;
  final void Function() onTap;
  const ChatInputSubmitButton({required this.internalMessageActive, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: AppSizes.s08,
      height: AppSizes.s08,
      decoration: ShapeDecoration(
        color: internalMessageActive ? colorScheme.tertiary : colorScheme.primary,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.s04),
        ),
      ),
      alignment: Alignment.center,
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Image.asset(
            AppIcons.send,
            width: AppSizes.s06,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
