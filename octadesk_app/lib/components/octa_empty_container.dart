import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/resources/app_illustrations.dart';
import 'package:octadesk_app/resources/index.dart';

class OctaEmptyContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  const OctaEmptyContainer({required this.title, required this.subtitle, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.s06, vertical: AppSizes.s08),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(AppIllustrations.searchIllustration, height: AppSizes.s40),
          const SizedBox(height: AppSizes.s12),
          OctaText.displayMedium(
            title,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.s06),
          OctaText(
            subtitle,
            textAlign: TextAlign.center,
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}
