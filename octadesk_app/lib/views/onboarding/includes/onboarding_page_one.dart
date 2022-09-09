import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/app_illustrations.dart';
import 'package:octadesk_app/views/onboarding/components/onboarding_button.dart';
import 'package:octadesk_app/views/onboarding/components/onboarding_page.dart';

class OnboardingPageOne extends StatelessWidget {
  final void Function() onClickNext;
  const OnboardingPageOne({required this.onClickNext, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnboardingPage(
      image: AppIllustrations.onboarding01,
      title: "Distribuição de conversas",
      subtitle: "Conecte os clientes de todos os canais de atendimento com um ou mais times de forma simples e automática.",
      footer: [
        Row(
          children: [
            OnboardingButton(onPressed: onClickNext, text: "Próximo"),
          ],
        )
      ],
    );
  }
}
