import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/resources/app_illustrations.dart';
import 'package:octadesk_app/resources/index.dart';

class ChatEmpty extends StatelessWidget {
  const ChatEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.s04),

      //
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppIllustrations.illustrationMessage,
            width: 180,
          ),
          const SizedBox(height: AppSizes.s10),
          Container(
            constraints: const BoxConstraints(maxWidth: 320),
            child: OctaText.headlineLarge(
              "Envie uma mensagem para iniciar essa conversa",
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
