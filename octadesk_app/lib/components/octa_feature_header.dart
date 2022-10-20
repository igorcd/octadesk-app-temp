import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';

class OctaFeatureHeader extends StatelessWidget {
  final TabController controller;
  final Widget? title;
  final List<Widget> Function(BuildContext context, int index) tabsBuilder;
  const OctaFeatureHeader({required this.controller, required this.title, required this.tabsBuilder, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.s04),
      child: Column(
        children: [
          if (title != null) title!,

          // Header
          Container(
            height: title != null ? AppSizes.s12 : AppSizes.s14,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ),
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                return Row(
                  children: tabsBuilder(context, controller.index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
