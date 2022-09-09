import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/components/responsive/responsive_container.dart';
import 'package:octadesk_app/components/responsive/utils/responsive.dart';
import 'package:octadesk_app/resources/index.dart';

class NoConversationSelected extends StatelessWidget {
  const NoConversationSelected({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      decoration: Responsive(
        const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Color.fromRGBO(0, 0, 0, .02),
              offset: Offset(10, 0),
            ),
          ],
        ),
        xxl: const BoxDecoration(
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(AppSizes.s04),
          ),
        ),
      ),
      padding: Responsive(const EdgeInsets.all(AppSizes.s04)),
      child: Center(
        child: OctaText.headlineLarge(
          "Selecione uma conversa para iniciar o atendimento",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
