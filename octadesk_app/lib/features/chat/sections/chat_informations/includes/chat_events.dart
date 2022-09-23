import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/features/chat/sections/chat_informations/components/event_list_tile.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_core/models/index.dart';

class ChatEvents extends StatelessWidget {
  final bool loading;
  final List<RoomEventModel> events;
  const ChatEvents({required this.loading, required this.events, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.s04),
        child: OctaText.bodySmall("Essa conversa não possui eventos"),
      );
    }

    if (events.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.s04),
        child: OctaText.bodySmall("Essa conversa não possui eventos"),
      );
    }

    return Column(
      children: events.map((e) => EventListTile(e)).toList(),
    );
  }
}
