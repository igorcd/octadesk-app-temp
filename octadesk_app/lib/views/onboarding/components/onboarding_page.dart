import 'package:flutter/material.dart';
import 'package:octadesk_app/components/octa_text.dart';
import 'package:octadesk_app/components/responsive/responsive_widgets.dart';
import 'package:octadesk_app/resources/index.dart';

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final double spacing;
  final List<Widget> footer;

  const OnboardingPage({required this.image, required this.title, required this.subtitle, this.spacing = AppSizes.s25, required this.footer, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.s04),
        constraints: const BoxConstraints(maxHeight: 650, maxWidth: 450),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ResponsiveContainer(
                    height: Responsive(
                      AppSizes.s60,
                      xs: AppSizes.s40,
                      md: 250,
                    ),
                    child: Image.asset(
                      image,
                    ),
                  ),
                  const SizedBox(height: AppSizes.s04),
                  SizedBox(
                    width: 250,
                    child: OctaText.headlineLarge(title, textAlign: TextAlign.center),
                  ),
                  const SizedBox(height: AppSizes.s04),
                  SizedBox(
                    width: 300,
                    height: 100,
                    child: OctaText(
                      subtitle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Flexible(
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: AppSizes.s12),
                    ),
                  )
                ],
              ),
            ),
            ...footer
          ],
        ),
      ),
    );
  }
}
