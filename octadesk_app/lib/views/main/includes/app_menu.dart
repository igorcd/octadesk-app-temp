import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/app_sizes.dart';

class AppMenu extends StatelessWidget {
  final List<Widget> menuItems;
  const AppMenu({required this.menuItems, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: AppSizes.s06, top: AppSizes.s05),
      width: AppSizes.s18,
      child: Column(
        children: menuItems,
      ),
    );
  }
}
