import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';

class OctaTag extends StatelessWidget {
  final bool active;
  final String placeholder;
  final void Function() onPressed;
  final String? icon;

  const OctaTag({this.active = false, required this.onPressed, required this.placeholder, this.icon, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    // var tagColor = colorScheme.primaryContainer;
    // var tagTextColor = colorScheme.onPrimaryContainer;
    var tagColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? AppColors.purple.shade700 : AppColors.purple.shade200;
    var tagTextColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? AppColors.purple.shade300 : AppColors.purple.shade600;

    return UnconstrainedBox(
      // Conteúdo principal
      child: Container(
        clipBehavior: Clip.hardEdge,
        height: AppSizes.s09,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(AppSizes.s02_5)),
          border: active ? null : Border.all(color: colorScheme.outline, width: 2),
          color: active ? tagColor : colorScheme.surface,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.s03),
              child: Row(
                children: [
                  if (icon != null)
                    // Ícone
                    Image.asset(
                      icon!,
                      width: AppSizes.s04,
                      color: active ? tagTextColor : colorScheme.onBackground,
                    ),
                  //
                  // Texto
                  Text(
                    placeholder,
                    style: TextStyle(
                      color: active ? tagTextColor : colorScheme.onBackground,
                      fontSize: AppSizes.s03_5,
                      fontWeight: active ? FontWeight.w400 : FontWeight.w500,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
