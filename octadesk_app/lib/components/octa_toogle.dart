import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';

class OctaToogle extends StatelessWidget {
  final bool active;
  final void Function(bool value)? onChange;

  const OctaToogle({required this.active, this.onChange, super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onChange != null ? () => onChange!(!active) : null,
      child: Container(
        height: AppSizes.s04,
        width: 30,
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.onSurface, width: 3),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              top: 1,
              left: active ? 14 : 2,
              duration: const Duration(milliseconds: 150),
              child: Container(
                width: AppSizes.s02,
                height: AppSizes.s02,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
