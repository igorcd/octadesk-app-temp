import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_app/utils/helper_functions.dart';
import 'package:octadesk_core/enums/room_event_type_enum.dart';
import 'package:octadesk_core/models/index.dart';

class EventListTile extends StatelessWidget {
  final RoomEventModel event;
  const EventListTile(this.event, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String eventText() {
      if (event.type == RoomEventTypeEnum.created) {
        return event.value;
      }
      if (event.type == RoomEventTypeEnum.agentChange) {
        var message = event.value.isEmpty ? "Conversa ficou sem atribuição" : "Conversa atribuída a ${event.value}";
        return message;
      }

      if (event.type == RoomEventTypeEnum.groupChange) {
        return "Conversa atribuida ao grupo ${event.value}";
      }

      return event.type.name;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.s04, vertical: AppSizes.s01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            dateTimeFormatterHelper().format(event.time),
            style: const TextStyle(
              fontSize: AppSizes.s03,
            ),
          ),
          Text(
            eventText(),
            style: const TextStyle(
              fontSize: AppSizes.s03,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
