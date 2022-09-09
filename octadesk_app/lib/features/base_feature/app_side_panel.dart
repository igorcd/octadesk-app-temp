import 'package:flutter/material.dart';
import 'package:octadesk_app/components/octa_icon_button.dart';
import 'package:octadesk_app/features/base_feature/app_menu_item.dart';

import '../../../resources/index.dart';

class AppSidePanel extends StatelessWidget {
  final List<Widget> content;
  final List<AppMenuItem> menuItems;
  final List<AppMenuItem> menuFooter;
  final List<Widget> footer;
  final bool showToogleMenuButton;
  final bool menuOpened;
  final void Function() onToogleMenu;

  const AppSidePanel({
    required this.content,
    required this.menuItems,
    required this.menuFooter,
    required this.footer,
    required this.menuOpened,
    required this.onToogleMenu,
    required this.showToogleMenuButton,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      width: 280,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            SizedBox(
              height: AppSizes.s23,
              child: Stack(
                children: [
                  //
                  // Nome do sistema
                  Positioned(
                    top: 22,
                    left: 0,
                    right: 0,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8, left: 20),
                          child: Image.asset(AppImages.appLogoIcon, width: 32),
                        ),
                        AnimatedOpacity(
                          opacity: menuOpened ? 1 : 0,
                          duration: const Duration(milliseconds: 150),
                          child: Image.asset(AppImages.appLogoText, height: 20),
                        ),
                      ],
                    ),
                  ),

                  // Botão de Toogle
                  if (showToogleMenuButton)
                    AnimatedPositioned(
                      top: 27,
                      right: menuOpened ? 15 : 225,
                      duration: const Duration(milliseconds: 150),
                      child: AnimatedRotation(
                        duration: const Duration(milliseconds: 150),
                        turns: menuOpened ? 0 : .5,
                        child: OctaIconButton(
                          iconSize: AppSizes.s05,
                          size: AppSizes.s06,
                          icon: AppIcons.angleLeft,
                          onPressed: onToogleMenu,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Container principal
            Expanded(
              child: Row(
                children: [
                  // Menu
                  SizedBox(
                    width: 72,
                    child: Column(
                      children: [
                        ...menuItems,
                        const Spacer(),
                        ...menuFooter,
                      ],
                    ),
                  ),

                  // Conteúdo
                  Expanded(
                    child: Container(
                      constraints: const BoxConstraints.expand(),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: content,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

            // Perfil
            ...footer,
          ],
        ),
      ),
    );
  }
}
