import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_core/octadesk_core.dart';

class ChatMessageClock extends StatelessWidget {
  final MessageStatusEnum status;
  final String time;

  const ChatMessageClock({required this.time, required this.status, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorSheme = Theme.of(context).colorScheme;

    Widget getStatusIcon() {
      switch (status) {
        case MessageStatusEnum.tryingToSend:
          return Image.asset("lib/assets/icons/sending.png", width: AppSizes.s04_5, key: const ValueKey("sending"), color: colorSheme.onBackground);

        case MessageStatusEnum.sending:
          return Image.asset("lib/assets/icons/sended.png", width: AppSizes.s04_5, key: const ValueKey("sending"), color: colorSheme.onBackground);

        case MessageStatusEnum.sended:
          return Image.asset("lib/assets/icons/sended.png", width: AppSizes.s04_5, key: const ValueKey("sended"), color: colorSheme.onBackground);

        case MessageStatusEnum.received:
          return Image.asset("lib/assets/icons/received.png", width: AppSizes.s04_5, key: const ValueKey("read"), color: colorSheme.onBackground);

        case MessageStatusEnum.read:
          return Image.asset("lib/assets/icons/read.png", width: AppSizes.s04_5, key: const ValueKey("read"));

        case MessageStatusEnum.error:
          return Image.asset("lib/assets/icons/error.png", width: AppSizes.s04_5, key: const ValueKey("error"), color: colorSheme.onBackground);

        default:
          return Image.asset("lib/assets/icons/read.png", width: AppSizes.s04_5, key: const ValueKey("read"), color: colorSheme.onBackground);
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: AppSizes.s01),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Horário
          Text(
            time,
            style: const TextStyle(
              fontSize: AppSizes.s03,
            ),
          ),
          const SizedBox(width: 2),
          // Mensagem recebida
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            child: getStatusIcon(),
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: child,
            ),
          )
        ],
      ),
    );
  }
}
