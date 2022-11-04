import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';

class OctaSearchSliver extends StatelessWidget {
  final void Function(String text) onTextChange;
  final bool loading;

  const OctaSearchSliver({required this.onTextChange, this.loading = false, Key? key}) : super(key: key);

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
      flexibleSpace: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: AppSizes.s04, right: AppSizes.s04, top: AppSizes.s03),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.s02_5),
                decoration: BoxDecoration(
                  color: colorScheme.background,
                  borderRadius: BorderRadius.circular(AppSizes.s02_5),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      AppIcons.search,
                      width: AppSizes.s06,
                      color: colorScheme.onSecondary,
                    ),
                    const SizedBox(width: AppSizes.s02),
                    Expanded(
                      child: TextField(
                        onChanged: onTextChange,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Pesquisar",
                          hintStyle: TextStyle(color: colorScheme.onSecondary, fontFamily: "Poppins", fontSize: AppSizes.s04, fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          LinearProgressIndicator(
            minHeight: 2,
            value: loading ? null : 0,
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
    );
  }
}
