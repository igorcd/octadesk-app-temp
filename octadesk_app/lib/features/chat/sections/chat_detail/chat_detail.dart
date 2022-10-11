import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/components/layout/new_messages_container.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/includes/chat_attachments.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/includes/chat_body.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/includes/chat_closing_details.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/includes/chat_footer.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/includes/chat_header.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/includes/chat_macros_container.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/includes/chat_mentions_container.dart';
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

        // Caso tenha carregado
        else {
          content = Container(
            constraints: const BoxConstraints.expand(),
            child: Stack(
              children: [
                // Conteúdo do chat
                Positioned.fill(
                  child: ChatBody(
                    room: snapshot.data,
                  ),
                ),

                // Loading da paginação
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  child: ValueListenableBuilder<bool>(
                    valueListenable: conversationDetailProvider.loadingPagination,
                    builder: (context, value, child) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: value ? const LinearProgressIndicator(minHeight: 2) : const SizedBox.shrink(),
                      );
                    },
                  ),
                ),

                // Container de novas mensagens
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ValueListenableBuilder<int>(
                    valueListenable: conversationDetailProvider.newMessagesLength,
                    builder: (context, value, child) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: value >= 0
                            ? NewMassagesContainer(
                                value,
                                onTap: conversationDetailProvider.refresh,
                              )
                            : const SizedBox.shrink(),
                      );
                    },
                  ),
                ),

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

            // Anexos
            if (conversationDetailProvider.attachedFiles.isNotEmpty) const ChatAttachments(),

            // Detalhes do fechamento
            if (snapshot.data?.closingDetails?.closedBy != null)
              ChatClosingDetails(
                userName: snapshot.data!.closingDetails!.closedBy.name,
              )

            // Input
            else
              const ChatFooter(),
          ],
        );
      },
    );
  }
}
