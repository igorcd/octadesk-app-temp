import 'package:flutter/material.dart';
import 'package:octadesk_app/components/octa_button.dart';
import 'package:octadesk_app/resources/app_illustrations.dart';
import 'package:octadesk_app/views/onboarding/components/onboarding_button.dart';
import 'package:octadesk_app/views/onboarding/components/onboarding_page.dart';

class OnboardingPageThree extends StatelessWidget {
  final void Function() login;
  final void Function() register;

  const OnboardingPageThree({required this.register, required this.login, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnboardingPage(
      image: AppIllustrations.onboarding03,
      title: "Histórico de conversas",
      subtitle: "Através do histórico das interações, crie uma experiência mais completa e personalizada para seus clientes.",
      footer: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Acessar
            OctaButton(text: "Acessar", onTap: login),

            // Criar conta
            Row(
              children: [
                OnboardingButton(
                  onPressed: register,
                  text: "Conheça o Octadesk",
                )
              ],
            )
          ],
        )
      ],
    );
  }
}
