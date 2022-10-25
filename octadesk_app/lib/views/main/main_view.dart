import 'package:flutter/material.dart';
import 'package:octadesk_app/components/responsive/responsive_widgets.dart';
import 'package:octadesk_app/utils/helper_functions.dart';
import 'package:octadesk_app/views/main/includes/app_menu_horizontal.dart';
import 'package:octadesk_app/views/main/includes/app_menu_vertical.dart';

class MainView extends StatelessWidget {
  final Widget currentFeature;
  final String currentFeatureLocation;
  const MainView({required this.currentFeature, required this.currentFeatureLocation, super.key});

  @override
  Widget build(BuildContext context) {
    var isMd = MediaQuery.of(context).size.width < ScreenSize.md;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Flex(
        direction: isMd ? Axis.vertical : Axis.horizontal,
        children: [
          // Menu Vertical
          if (!isMd) AppMenuVertical(currentFeatureLocation),

          Expanded(
            child: currentFeature,
          ),

          if (isMd)
            ValueListenableBuilder<bool>(
              valueListenable: getNavigationBarVisibility(),
              builder: (context, value, child) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 100),
                  switchInCurve: Curves.ease,
                  switchOutCurve: Curves.ease,
                  transitionBuilder: (child, animation) {
                    return SizeTransition(
                      axisAlignment: -1,
                      sizeFactor: animation,
                      axis: Axis.vertical,
                      child: child,
                    );
                  },
                  child: value ? AppMenuHorizontal(currentFeatureLocation) : const SizedBox.shrink(),
                );
              },
            )
        ],
      ),
    );
  }
}
