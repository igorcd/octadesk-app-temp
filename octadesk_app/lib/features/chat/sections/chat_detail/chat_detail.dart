import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/includes/chat_body.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/includes/chat_empty.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/includes/chat_footer.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/includes/chat_header.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/includes/chat_macros_container.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/includes/chat_mentions_container.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/includes/chat_skeleton.dart';
import 'package:octadesk_app/features/chat/providers/chat_detail_provider.dart';
import 'package:octadesk_core/models/room/room_model.dart';
import 'package:provider/provider.dart';

class ChatDetail extends StatelessWidget {
  const ChatDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var conversationDetailProvider = Provider.of<ChatDetailProvider>(context);

    return StreamBuilder<RoomModel?>(
      stream: conversationDetailProvider.roomDetailStream,
      builder: (context, snapshot) {
        Widget content;

        // Erro
        if (snapshot.hasError) {
          content = OctaErrorContainer(subtitle: snapshot.error.toString());
        }

        // Caso esteja carregando
        else if (snapshot.data is! RoomModel || snapshot.connectionState == ConnectionState.done) {
          content = const ChatSkeleton();
        }

        // Caso tenha carregado
        else {
          content = Container(
            constraints: const BoxConstraints.expand(),
            child: Stack(
              children: [
                // Conteúdo do chat
                Positioned.fill(
                    child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: snapshot.data!.messages.isEmpty
                      ? const ChatEmpty()
                      : ChatBody(
                          scrollController: conversationDetailProvider.scrollController,
                          room: snapshot.data!,
                        ),
                )),

                // Container de macros
                const ChatMacrosContainer(),

                // Container de menções
                const ChatMentionsContainer(),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            const ChatHeader(),

            // Conteúdo
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: content,
              ),
            ),

            // Footer
            const ChatFooter(),
          ],
        );
      },
    );
  }
}
