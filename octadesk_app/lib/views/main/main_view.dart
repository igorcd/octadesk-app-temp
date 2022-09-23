import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_app/views/main/components/app_menu_item.dart';
import 'package:octadesk_app/views/main/components/app_user_button.dart';
import 'package:octadesk_app/views/main/includes/app_menu.dart';

class MainView extends StatelessWidget {
  final Widget currentFeature;
  const MainView({required this.currentFeature, super.key});

  @override
  Widget build(BuildContext context) {
    var route = GoRouter.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Row(
        children: [
          // Menu
          AppMenu(
            menuItems: [
              //
              // Chat
              AppMenuItem(
                selected: route.location == '/main',
                icon: AppIcons.chatIcon,
                selectedIcon: AppIcons.chatFillIcon,
                onTap: () => route.go('/main'),
              ),

              // Bot
              AppMenuItem(
                selected: route.location == '/bot',
                icon: AppIcons.botIcon,
                selectedIcon: AppIcons.botFillIcon,
                onTap: () => route.go('/bot'),
              ),

              // Dashboard
              AppMenuItem(
                selected: route.location == '/dashboards',
                icon: AppIcons.dashboardIcon,
                selectedIcon: AppIcons.dashboardFillIcon,
                onTap: () => route.go('/dashboards'),
              ),

              // Usuários
              AppMenuItem(
                selected: route.location == '/users',
                icon: AppIcons.usersIcon,
                selectedIcon: AppIcons.usersFillIcon,
                onTap: () => route.go('/users'),
              ),

              const Spacer(),

              // Configurações
              AppMenuItem(
                selected: route.location == '/settings',
                icon: AppIcons.settingsIcon,
                selectedIcon: AppIcons.settingsIconFill,
                onTap: () => route.go('/settings'),
              ),

              // Ajuda
              AppMenuItem(
                selected: false,
                icon: AppIcons.helpIcon,
                onTap: () {},
              ),

              // Notificações
              AppMenuItem(
                selected: false,
                icon: AppIcons.notificationIcon,
                onTap: () {},
              ),
              const SizedBox(height: AppSizes.s04),
              const AppUserButton(),
            ],
          ),

          const VerticalDivider(),
          Expanded(
            child: currentFeature,
          )
        ],
      ),
    );
  }
}
