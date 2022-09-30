import 'package:flutter/cupertino.dart';
import 'package:octadesk_app/components/octa_text.dart';
import 'package:octadesk_app/features/chat/providers/chat_detail_provider.dart';
import 'package:octadesk_app/features/chat/sections/chat_informations/components/chat_history_button.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_core/octadesk_core.dart';
import 'package:provider/provider.dart';

class ChatHistory extends StatelessWidget {
  final void Function(RoomModel room) onOpenConversation;
  const ChatHistory({required this.onOpenConversation, super.key});

  @override
  Widget build(BuildContext context) {
    ChatDetailProvider provider = Provider.of(context);

    return FutureBuilder<List<RoomModel>>(
      future: provider.lastConversationsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return OctaText.bodySmall("Não foi possível carregar as últimas conversas");
        }
        if (snapshot.data == null) {
          return OctaText.bodySmall("Carregando");
        }

        if (snapshot.data!.isEmpty) {
          return OctaText.bodySmall("Não há conversas");
        }

        return ListView.separated(
          padding: const EdgeInsets.only(left: AppSizes.s04, right: AppSizes.s04, bottom: AppSizes.s04),
          shrinkWrap: true,
          itemCount: snapshot.data!.length,
          separatorBuilder: (c, i) => const SizedBox(height: AppSizes.s02),
          itemBuilder: (context, index) {
            var room = snapshot.data![index];
            return ChatHistoryButton(date: room.createdAt, onTap: () => onOpenConversation(room));
          },
        );
      },
    );
  }
}
