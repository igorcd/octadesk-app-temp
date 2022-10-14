import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:octadesk_app/resources/app_sizes.dart';
import 'package:octadesk_app/views/main/components/app_menu_item.dart';
import 'package:octadesk_app/views/main/components/app_user_button.dart';

import '../../../resources/app_icons.dart';

class AppMenuVertical extends StatelessWidget {
  final String currentFeatureLocation;
  const AppMenuVertical(this.currentFeatureLocation, {super.key});

  @override
  Widget build(BuildContext context) {
    var route = GoRouter.of(context);

    return Container(
      padding: const EdgeInsets.only(bottom: AppSizes.s06, top: AppSizes.s05),
      width: AppSizes.s18,
      child: Column(
        children: [
          //
          // Chat
          AppMenuItem(
            selected: currentFeatureLocation == '/main',
            icon: AppIcons.chatIcon,
            selectedIcon: AppIcons.chatFillIcon,
            onTap: () => route.go('/main'),
          ),

          // // Bot
          // AppMenuItem(
          //   selected: currentFeatureLocation == '/bot',
          //   icon: AppIcons.botIcon,
          //   selectedIcon: AppIcons.botFillIcon,
          //   onTap: () => route.go('/bot'),
          // ),

          // // Dashboard
          // AppMenuItem(
          //   selected: currentFeatureLocation == '/dashboards',
          //   icon: AppIcons.dashboardIcon,
          //   selectedIcon: AppIcons.dashboardFillIcon,
          //   onTap: () => route.go('/dashboards'),
          // ),

          // Usuários
          AppMenuItem(
            selected: currentFeatureLocation == '/users',
            icon: AppIcons.usersIcon,
            selectedIcon: AppIcons.usersFillIcon,
            onTap: () => route.go('/users'),
          ),

          const Spacer(),

          // Configurações
          AppMenuItem(
            selected: currentFeatureLocation == '/settings',
            icon: AppIcons.settingsIcon,
            selectedIcon: AppIcons.settingsIconFill,
            onTap: () => route.go('/settings'),
          ),

          // // Ajuda
          // AppMenuItem(
          //   selected: false,
          //   icon: AppIcons.helpIcon,
          //   onTap: () {},
          // ),

          // // Notificações
          // AppMenuItem(
          //   selected: false,
          //   icon: AppIcons.notificationIcon,
          //   onTap: () {},
          // ),
          const SizedBox(height: AppSizes.s04),
          const AppUserButton(),
        ],
      ),
    );
  }
}
