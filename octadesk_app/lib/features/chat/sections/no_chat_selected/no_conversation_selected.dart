import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/resources/index.dart';

class NoConversationSelected extends StatelessWidget {
  const NoConversationSelected({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.s08),
        child: OctaText.headlineLarge(
          "Selecione uma conversa para iniciar o atendimento",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
