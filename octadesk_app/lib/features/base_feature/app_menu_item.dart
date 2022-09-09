import 'package:flutter/material.dart';

class AppMenuItem extends StatelessWidget {
  final bool selected;
  final String icon;
  final String? selectedIcon;
  final void Function() onTap;

  const AppMenuItem({
    this.selected = false,
    this.selectedIcon,
    required this.onTap,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 48,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                bottom: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  color: const Color(0xff29354D),
                  width: selected ? 4 : 0,
                ),
              ),
              Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: selected && selectedIcon != null
                      ? Image.asset(
                          key: const ValueKey("selected"),
                          selectedIcon!,
                          width: 24,
                        )
                      : Image.asset(
                          key: const ValueKey("unselected"),
                          icon,
                          width: 24,
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
