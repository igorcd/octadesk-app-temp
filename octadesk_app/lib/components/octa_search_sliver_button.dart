import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/app_icons.dart';
import 'package:octadesk_app/resources/app_sizes.dart';

class OctaSearchSliverButton extends StatelessWidget {
  const OctaSearchSliverButton({super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return SliverAppBar(
      elevation: 0,
      floating: true,
      backgroundColor: colorScheme.surface,
      leading: null,
      automaticallyImplyLeading: false,
      toolbarHeight: 65,
      primary: false,
      flexibleSpace: Padding(
        padding: const EdgeInsets.only(right: AppSizes.s04_5, left: AppSizes.s04_5, top: AppSizes.s04),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.s03_5),
          height: AppSizes.s12,
          decoration: BoxDecoration(
            color: colorScheme.background,
            borderRadius: BorderRadius.circular(AppSizes.s02_5),
          ),
          child: Row(children: [
            Image.asset(
              AppIcons.search,
              width: AppSizes.s06,
              color: colorScheme.onSecondary,
            ),
            const SizedBox(width: AppSizes.s02),
            Text(
              "Buscar conversa",
              style: TextStyle(
                color: colorScheme.onSecondary,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
