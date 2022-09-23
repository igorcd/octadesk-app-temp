import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';

class AppWindowsToolbar extends StatefulWidget {
  final Widget child;
  const AppWindowsToolbar(this.child, {super.key});

  @override
  State<AppWindowsToolbar> createState() => _AppWindowsToolbarState();
}

class _AppWindowsToolbarState extends State<AppWindowsToolbar> {
  void maximizeOrRestore() {
    setState(() {
      appWindow.maximizeOrRestore();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = WindowButtonColors(
      iconNormal: Theme.of(context).colorScheme.onBackground,
      mouseOver: Theme.of(context).colorScheme.onSurface,
      mouseDown: Theme.of(context).colorScheme.onSurface,
      iconMouseOver: Theme.of(context).colorScheme.onBackground,
      iconMouseDown: Theme.of(context).colorScheme.onBackground,
    );

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: AppSizes.s08,
            color: MediaQuery.of(context).platformBrightness == Brightness.dark ? AppColors.info.shade900 : AppColors.info.shade100,
            child: Row(
              children: [
                Expanded(
                  child: MoveWindow(),
                ),
                Row(
                  children: [
                    MinimizeWindowButton(
                      colors: colors,
                    ),
                    appWindow.isMaximized
                        ? RestoreWindowButton(
                            onPressed: maximizeOrRestore,
                            colors: colors,
                          )
                        : MaximizeWindowButton(
                            onPressed: maximizeOrRestore,
                            colors: colors,
                          ),
                    CloseWindowButton(
                      colors: colors,
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(child: widget.child)
        ],
      ),
    );
  }
}
