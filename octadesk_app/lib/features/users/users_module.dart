import 'package:flutter/material.dart';
import 'package:octadesk_app/features/base_feature/app_side_panel_group.dart';
import 'package:octadesk_app/features/base_feature/app_side_panel_item.dart';
import 'package:octadesk_app/router/features_router.dart';

import '../base_feature/octa_feature.dart';

class UsersModule extends StatelessWidget {
  const UsersModule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const OctaFeature(
      selectedMenu: FeaturesRouter.usersModule,
      menu: [
        AppSidePanelGroup(
          title: "Usuários",
          items: [
            AppSidePanelItem(label: "Menu 1", selected: false),
            AppSidePanelItem(label: "Menu 2", selected: false),
          ],
        )
      ],
      content: Text("Chat"),
    );
  }
}
