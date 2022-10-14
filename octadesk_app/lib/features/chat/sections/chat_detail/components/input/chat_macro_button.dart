import 'package:flutter/material.dart';
import 'package:octadesk_app/components/octa_icon_button.dart';
import 'package:octadesk_app/resources/app_icons.dart';
import 'package:octadesk_app/resources/app_sizes.dart';

class ChatMacroButton extends StatelessWidget {
  final bool active;
  final void Function() onTap;
  const ChatMacroButton({required this.active, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.s02),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 150),
        transitionBuilder: (child, animation) {
          return SizeTransition(
            sizeFactor: animation,
            axis: Axis.horizontal,
            axisAlignment: 0,
            child: child,
          );
        },
        child: active
            ? Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.s01_5),
                  decoration: BoxDecoration(
                    border: Border(right: BorderSide(color: colorScheme.outline)),
                  ),
                  child: OctaIconButton(
                    borderRadius: AppSizes.s01,
                    onPressed: onTap,
                    icon: AppIcons.macro,
                    size: AppSizes.s08,
                    iconSize: AppSizes.s06,
                    color: colorScheme.onSecondary,
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
