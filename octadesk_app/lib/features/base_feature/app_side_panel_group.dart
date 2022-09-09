import 'package:flutter/material.dart';
import 'package:octadesk_app/components/octa_text.dart';
import 'package:octadesk_app/features/base_feature/app_side_panel_item.dart';

import '../../../resources/index.dart';

class AppSidePanelGroup extends StatelessWidget {
  final List<AppSidePanelItem> items;
  final String title;
  const AppSidePanelGroup({required this.title, required this.items, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.s04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: AppSizes.s03_5, right: AppSizes.s03_5, bottom: AppSizes.s02_5),
            child: OctaText.headlineSmall(title),
          ),
          ...items,
        ],
      ),
    );
  }
}
