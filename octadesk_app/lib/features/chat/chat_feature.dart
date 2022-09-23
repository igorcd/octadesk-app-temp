import 'package:flutter/material.dart';
import 'package:octadesk_app/features/chat/sections/chat_informations/chat_informations.dart';
import 'package:octadesk_app/features/chat/sections/chat_menu/chat_menu.dart';
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

    // Sessões
    const chatFeatureMenu = ChatMenu();
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
                Expanded(
                  child: ChangeNotifierProvider.value(
                    value: conversationProvider.currentConversation,
                    child: conversationDetail,
                  ),
                ),
                const VerticalDivider(),
                SizedBox(
                  width: 250,
                  child: ChangeNotifierProvider.value(
                    value: conversationProvider.currentConversation,
                    child: conversationInformations,
                  ),
                )
              ],
            );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        //
        // Menu Lateral
        const SizedBox(
          width: 280,
          child: chatFeatureMenu,
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
                const SizedBox(
                  width: 340,
                  child: conversationsList,
                ),
                const VerticalDivider(),
                Expanded(
                  child: content(),
                ),
                // Listagem de conversas
              ],
            ),
          ),
        )
      ],
    );
  }
}
