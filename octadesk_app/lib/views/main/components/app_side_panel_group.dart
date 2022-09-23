import 'package:flutter/material.dart';
import 'package:octadesk_app/components/octa_text.dart';
import 'package:octadesk_app/views/main/components/app_side_panel_item.dart';

import '../../../resources/index.dart';

class AppSidePanelGroup extends StatelessWidget {
  final List<AppSidePanelItem> items;
  final String title;
  const AppSidePanelGroup({required this.title, required this.items, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.s04),

      // Items
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Título do grupo
          Padding(
            padding: const EdgeInsets.only(left: AppSizes.s05, right: AppSizes.s05, bottom: AppSizes.s02_5),
            child: OctaText.headlineSmall(title),
          ),
          ...items,
        ],
      ),
    );
  }
}
