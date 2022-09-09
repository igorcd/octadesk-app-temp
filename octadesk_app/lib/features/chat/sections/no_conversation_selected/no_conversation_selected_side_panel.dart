import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';

class NoConversationSelectSidePanel extends StatelessWidget {
  const NoConversationSelectSidePanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        //
        // Container superior
        Container(
          height: 200,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(AppSizes.s04),
            ),
          ),
        ),

        // Informações do usuário

        const SizedBox(height: AppSizes.s03),
        // Informações da conversa
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(AppSizes.s04),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
