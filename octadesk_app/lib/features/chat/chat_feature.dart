import 'package:flutter/material.dart';
import 'package:octadesk_app/components/responsive/responsive_widgets.dart';
import 'package:octadesk_app/features/chat/sections/chat_informations/chat_informations.dart';
import 'package:octadesk_app/features/chat/sections/chat_inbox/chat_inbox.dart';
import 'package:octadesk_app/features/chat/store/chat_store.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/chat_detail.dart';
import 'package:octadesk_app/features/chat/sections/chat_list/chat_list.dart';
import 'package:octadesk_app/features/chat/sections/no_chat_selected/no_conversation_selected.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:provider/provider.dart';

class ChatFeature extends StatelessWidget {
  const ChatFeature({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var conversationProvider = Provider.of<ChatStore>(context);
    var screenSize = MediaQuery.of(context).size.width;

    // Sessões
    const chatInbox = ChatInbox();
    const conversationsList = ChatList();
    const conversationDetail = ChatDetail();
    const conversationInformations = ChatInformations();

    /// Conteúdo do detalhe
    Widget content() {
      return conversationProvider.currentConversation == null

          // Caso não tenha nenhuma conversa selecionada
          ? const NoConversationSelected()

          // Detalhe da conversa
          : Row(
              children: [
                // Mensagens
                Expanded(
                  child: ChangeNotifierProvider.value(
                    value: conversationProvider.currentConversation,
                    child: conversationDetail,
                  ),
                ),

                // Informações da conversa
                if (screenSize >= ScreenSize.xxl) ...[
                  const VerticalDivider(indent: 0, endIndent: 0),
                  SizedBox(
                    width: 250,
                    child: ChangeNotifierProvider.value(
                      value: conversationProvider.currentConversation,
                      child: conversationInformations,
                    ),
                  )
                ]
              ],
            );
    }

    // Layout landscape
    if (screenSize >= ScreenSize.md) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //
          // Inbox
          if (screenSize >= ScreenSize.xl)
            const SizedBox(
              key: ValueKey("Inbox"),
              width: 280,
              child: chatInbox,
            ),

          // Conteúdo
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(AppSizes.s08)),
              ),
              child: Row(
                children: [
                  //
                  // Lista de conversas
                  const SizedBox(
                    width: 340,
                    child: conversationsList,
                  ),
                  const VerticalDivider(indent: 1, endIndent: 1),

                  // Conteúdo principal
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: content(),
                    ),
                  ),
                  // Listagem de conversas
                ],
              ),
            ),
          )
        ],
      );
    }

    /// Layout Mobile
    return LayoutBuilder(
      builder: (c, constraints) {
        return Container(
          color: Theme.of(context).colorScheme.surface,
          child: Stack(
            children: [
              // Lista de conversas
              const Positioned.fill(
                child: conversationsList,
              ),

              // Detalhe da conversa
              AnimatedPositioned(
                height: constraints.maxHeight,
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
                top: conversationProvider.currentConversationOpened ? 0 : constraints.maxHeight,
                right: 0,
                left: 0,
                child: content(),
              ),
            ],
          ),
        );
      },
    );
  }
}
