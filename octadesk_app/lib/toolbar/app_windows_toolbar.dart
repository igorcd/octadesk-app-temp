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

  final colors = WindowButtonColors(
    iconNormal: Colors.black87,
    mouseOver: Colors.grey.shade400,
    mouseDown: Colors.grey.shade500,
    iconMouseOver: Colors.black87,
    iconMouseDown: Colors.black87,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: AppSizes.s08,
            color: Colors.grey.shade200,
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
                    CloseWindowButton(),
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
