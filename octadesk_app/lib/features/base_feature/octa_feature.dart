import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:octadesk_app/components/responsive/responsive_widgets.dart';
import 'package:octadesk_app/features/base_feature/app_menu_item.dart';
import 'package:octadesk_app/features/base_feature/app_side_panel.dart';
import 'package:octadesk_app/features/base_feature/app_user_button.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_app/router/features_router.dart';

class OctaFeature extends StatefulWidget {
  final List<Widget> menu;
  final Widget content;
  final String selectedMenu;
  const OctaFeature({required this.selectedMenu, required this.menu, required this.content, Key? key}) : super(key: key);

  @override
  State<OctaFeature> createState() => _OctaFeatureState();
}

class _OctaFeatureState extends State<OctaFeature> {
  bool _menuOpened = true;
  final GlobalKey<ScaffoldState> mainScaffold = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    void toogleMenu() {
      // Caso esteja no tamanho tablet, interagir com o Drawer
      if (screenWidth < ScreenSize.xl) {
        var isDrawerOpened = mainScaffold.currentState?.isDrawerOpen ?? false;
        if (isDrawerOpened) {
          mainScaffold.currentState?.closeDrawer();
        } else {
          mainScaffold.currentState?.openDrawer();
        }

        return;
      }

      // Abrir o menu
      setState(() {
        _menuOpened = !_menuOpened;
      });
    }

    double calcContentLeftPosition() {
      if (screenWidth < ScreenSize.lg) {
        return 0;
      } else if (screenWidth < ScreenSize.xl) {
        return 75;
      } else {
        return _menuOpened ? 280 : 75;
      }
    }

    /// Menu Lateral
    Widget sidePanel({bool forceOpened = false}) {
      var menuSize = calcContentLeftPosition();
      var opened = menuSize == 280 || menuSize == 0;

      return AppSidePanel(
        menuOpened: opened || forceOpened,
        showToogleMenuButton: screenWidth >= ScreenSize.lg,
        onToogleMenu: toogleMenu,
        menuItems: [
          AppMenuItem(
            icon: AppIcons.chatIcon,
            selectedIcon: AppIcons.chatFillIcon,
            selected: widget.selectedMenu == FeaturesRouter.chatModule,
            onTap: () => FeaturesRouter.featuresNavigator.currentState?.pushReplacementNamed(FeaturesRouter.chatModule),
          ),
          // AppMenuItem(
          //   icon: AppIcons.botIcon,
          //   selectedIcon: AppIcons.botFillIcon,
          //   selected: false,
          //    onTap: () => FeaturesRouter.featuresNavigator.currentState?.pushReplacementNamed(FeaturesRouter.usersModule),
          // ),
          // AppMenuItem(
          //   icon: AppIcons.dashboardIcon,
          //   selectedIcon: AppIcons.dashboardFillIcon,
          //   selected: false,
          // ),
          AppMenuItem(
            icon: AppIcons.usersIcon,
            selectedIcon: AppIcons.usersFillIcon,
            selected: widget.selectedMenu == FeaturesRouter.usersModule,
            onTap: () => FeaturesRouter.featuresNavigator.currentState?.pushReplacementNamed(FeaturesRouter.usersModule),
          ),
        ],
        menuFooter: [
          AppMenuItem(
            icon: AppIcons.notificationIcon,
            selected: false,
            onTap: () {},
          ),
          AppMenuItem(
            icon: AppIcons.helpIcon,
            selected: false,
            onTap: () {},
          ),
          AppMenuItem(
            icon: AppIcons.settingsIcon,
            selected: false,
            onTap: () {},
          ),
        ],
        content: widget.menu,
        footer: [
          AppUserButton(menuOpened: opened || forceOpened),
        ],
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        key: mainScaffold,
        drawer: Drawer(
          child: sidePanel(forceOpened: true),
        ),
        // drawer: sidePanel(forceOpened: true),
        drawerEnableOpenDragGesture: screenWidth < 1366,
        backgroundColor: Colors.grey.shade200,
        body: Stack(
          children: [
            // Menu Lateral
            if (screenWidth >= ScreenSize.lg)
              Positioned(
                top: 0,
                left: 0,
                bottom: 0,
                child: sidePanel(),
              ),

            // Container principal
            AnimatedPositioned(
              top: 0,
              right: 0,
              bottom: 0,
              curve: Curves.ease,
              left: calcContentLeftPosition(),
              duration: const Duration(milliseconds: 150),

              // Conteúdo principal
              child: ResponsiveContainer(
                clipBehavior: Clip.hardEdge,
                decoration: Responsive(
                  const BoxDecoration(color: Colors.white),
                  lg: const BoxDecoration(
                    boxShadow: [BoxShadow(blurRadius: 20, color: Color.fromRGBO(0, 0, 0, .07))],
                    borderRadius: BorderRadius.horizontal(left: Radius.circular(AppSizes.s04)),
                  ),
                ),
                child: SafeArea(bottom: false, child: widget.content),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
