import 'dart:io';

import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_app/toolbar/app_windows_toolbar.dart';

double kAppToolbarHeight = Platform.isWindows ? AppSizes.s08 : 0;

class AppToolbar extends StatelessWidget {
  final Widget child;
  const AppToolbar({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isWindows) {
      return AppWindowsToolbar(child);
    }

    return child;
  }
}
