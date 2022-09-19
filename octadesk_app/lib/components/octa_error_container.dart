import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/resources/app_illustrations.dart';
import 'package:octadesk_app/resources/index.dart';

class OctaErrorContainer extends StatelessWidget {
  final String subtitle;
  final String? error;
  final void Function()? onTryAgain;
  final String tryAgainText;
  final bool showIllustration;
  const OctaErrorContainer({required this.subtitle, this.error, this.onTryAgain, this.tryAgainText = "Tentar novamente", this.showIllustration = true, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.s06),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(AppIllustrations.illustrationError, height: AppSizes.s40),
          const SizedBox(height: AppSizes.s06),
          OctaText.headlineMedium(
            "Opss...",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.s04),
          OctaText(
            subtitle,
            textAlign: TextAlign.center,
            maxLines: 3,
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSizes.s04),
              child: Text(
                error!,
                style: TextStyle(fontSize: AppSizes.s03, fontWeight: FontWeight.bold, color: AppColors.info.shade300),
                textAlign: TextAlign.center,
                maxLines: 3,
              ),
            ),
          if (onTryAgain != null)
            Container(
              margin: const EdgeInsets.only(top: AppSizes.s04),
              height: AppSizes.s09,
              child: OctaButton(
                onTap: onTryAgain!,
                text: tryAgainText,
              ),
            )
        ],
      ),
    );
  }
}
