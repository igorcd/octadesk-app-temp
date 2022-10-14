import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/app_sizes.dart';
import '../../../resources/app_colors.dart';

class AppMenuItem extends StatelessWidget {
  final bool selected;
  final String icon;
  final String? selectedIcon;
  final void Function() onTap;
  final bool disableSelectedForeground;

  const AppMenuItem({required this.onTap, required this.selected, required this.icon, this.selectedIcon, this.disableSelectedForeground = false, super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.s03, vertical: AppSizes.s00_5),
      child: AspectRatio(
        aspectRatio: 1,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          clipBehavior: Clip.hardEdge,
          decoration: ShapeDecoration(
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            color: selected && !disableSelectedForeground ? colorScheme.surfaceVariant : colorScheme.surfaceVariant.withOpacity(0),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  child: Image.asset(
                    key: ValueKey(selected),
                    selected ? selectedIcon ?? icon : icon,
                    color: selected ? colorScheme.onSurfaceVariant : AppColors.info.shade400,
                    width: AppSizes.s07,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
