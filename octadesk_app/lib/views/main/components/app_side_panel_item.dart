import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';

class AppSidePanelItem extends StatelessWidget {
  final String label;
  final String? trailing;
  final bool selected;
  final void Function()? onTap;
  const AppSidePanelItem({this.onTap, this.trailing, required this.label, required this.selected, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(AppSizes.s02),
      clipBehavior: Clip.hardEdge,
      color: selected ? Theme.of(context).colorScheme.surface : Colors.transparent,

      // Botão
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.s05, vertical: AppSizes.s02_5),

          // Opacidade
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: AppSizes.s03_5,
                    color: selected ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onBackground,
                    fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
              if (trailing != null)
                Text(
                  trailing!,
                  style: TextStyle(
                    fontSize: AppSizes.s03,
                    color: selected ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onBackground,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
