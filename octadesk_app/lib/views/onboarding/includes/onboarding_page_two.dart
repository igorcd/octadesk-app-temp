import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/app_illustrations.dart';
import 'package:octadesk_app/views/onboarding/components/onboarding_button.dart';
import 'package:octadesk_app/views/onboarding/components/onboarding_page.dart';

class OnboardingPageTwo extends StatelessWidget {
  final void Function() onClickNext;
  final void Function() onClickPrev;
  const OnboardingPageTwo({required this.onClickNext, required this.onClickPrev, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnboardingPage(
      image: AppIllustrations.onboarding02,
      title: "Atendimentos mais ágeis",
      subtitle: "Com as conversas organizadas automaticamente em uma só caixa de entrada, tenha mais agilidade nos atendimentos.",
      footer: [
        Row(
          children: [
            OnboardingButton(onPressed: onClickPrev, secondary: true, text: "Voltar"),
            OnboardingButton(onPressed: onClickNext, text: "Próximo"),
          ],
        )
      ],
    );
  }
}
