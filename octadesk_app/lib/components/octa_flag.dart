import 'package:flutter/material.dart';

class OctaFlag extends StatelessWidget {
  final String flag;
  const OctaFlag({required this.flag, super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: colorScheme.background),
      clipBehavior: Clip.hardEdge,
      width: 20,
      height: 14,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 150),
        child: flag.isNotEmpty
            ? Image.asset(
                'lib/assets/flags/$flag.png',
              )
            : null,
      ),
    );
  }
}
