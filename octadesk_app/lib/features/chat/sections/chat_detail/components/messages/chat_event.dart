import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_core/enums/room_event_type_enum.dart';
import 'package:octadesk_core/octadesk_core.dart';

class ChatEvent extends StatelessWidget {
  final RoomEventModel event;

  const ChatEvent({required this.event, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    Widget renderEvent(String message, String boldMessage) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.s03),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: message,
            style: TextStyle(
              color: colorScheme.onBackground,
              fontSize: AppSizes.s03,
            ),
            children: [
              TextSpan(
                text: boldMessage,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onBackground,
                  fontSize: AppSizes.s03,
                ),
              )
            ],
          ),
        ),
      );
    }

    if (event.type == RoomEventTypeEnum.agentChange) {
      var message = event.value.isEmpty ? "Conversa ficou sem atribuição" : "Conversa atribuída a ";
      var boldMessage = event.value;
      return renderEvent(message, boldMessage);
    }

    if (event.type == RoomEventTypeEnum.groupChange && event.value.isNotEmpty) {
      return renderEvent("Conversa atribuida ao grupo ", event.value);
    }
    return const SizedBox.shrink();
  }
}
