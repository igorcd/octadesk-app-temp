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
      toolbarHeight: 60,
      primary: false,
      flexibleSpace: Padding(
        padding: const EdgeInsets.only(left: AppSizes.s04, right: AppSizes.s04, top: AppSizes.s03),
        child: Container(
          clipBehavior: Clip.hardEdge,
          height: AppSizes.s10,
          decoration: BoxDecoration(
            color: colorScheme.background,
            borderRadius: BorderRadius.circular(AppSizes.s02_5),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.s02_5),
                child: Row(children: [
                  Image.asset(
                    AppIcons.search,
                    width: AppSizes.s06,
                    color: colorScheme.onSecondary,
                  ),
                  const SizedBox(width: AppSizes.s02),
                  Text(
                    "Pesquisar",
                    style: TextStyle(color: colorScheme.onSecondary, fontFamily: "Poppins", fontSize: AppSizes.s04, fontWeight: FontWeight.w500),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
