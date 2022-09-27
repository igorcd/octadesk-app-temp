import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';

class ConversationHeaderTab extends StatelessWidget {
  final String? label;
  final bool selected;
  final Widget? child;
  final void Function() onTap;
  const ConversationHeaderTab({this.label, this.child, required this.selected, required this.onTap, super.key}) : assert(label != null || child != null);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    // Opacidade
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: selected ? 1 : .3,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(right: AppSizes.s01, left: AppSizes.s01, top: AppSizes.s03),
        height: AppSizes.s15,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 2,
              color: selected ? colorScheme.onSurface : colorScheme.onSurface.withOpacity(0),
            ),
          ),
        ),
        child: Material(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSizes.s02)),
          clipBehavior: Clip.hardEdge,
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.s02),
              child: Center(
                child: label != null
                    ? Text(
                        label!,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                          fontSize: AppSizes.s04,
                        ),
                      )
                    : child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
