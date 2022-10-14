import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:octadesk_app/resources/app_icons.dart';
import 'package:octadesk_app/resources/app_sizes.dart';
import 'package:octadesk_app/views/main/components/app_menu_item.dart';
import 'package:octadesk_app/views/main/components/app_user_button.dart';

class AppMenuHorizontal extends StatelessWidget {
  final String currentFeatureLocation;
  const AppMenuHorizontal(this.currentFeatureLocation, {super.key});

  @override
  Widget build(BuildContext context) {
    var route = GoRouter.of(context);
    var colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(width: 1, color: colorScheme.outline)),
      ),
      // Container principal
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.s00_5),
        height: AppSizes.s14,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppMenuItem(
              selected: currentFeatureLocation == '/main',
              icon: AppIcons.chatIcon,
              selectedIcon: AppIcons.chatFillIcon,
              onTap: () => route.go('/main'),
              disableSelectedForeground: true,
            ),
            // Usuários
            AppMenuItem(
              selected: currentFeatureLocation == '/users',
              icon: AppIcons.usersIcon,
              selectedIcon: AppIcons.usersFillIcon,
              onTap: () => route.go('/users'),
              disableSelectedForeground: true,
            ),

            // Configurações
            AppMenuItem(
              selected: currentFeatureLocation == '/settings',
              icon: AppIcons.settingsIcon,
              selectedIcon: AppIcons.settingsIconFill,
              onTap: () => route.go('/settings'),
              disableSelectedForeground: true,
            ),

            // Usuário
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.s03, vertical: AppSizes.s00_5),
              child: AppUserButton(),
            )
          ],
        ),
      ),
    );
  }
}
