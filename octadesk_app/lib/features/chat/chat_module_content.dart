import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/components/responsive/responsive_widgets.dart';
import 'package:octadesk_app/components/responsive/utils/screen_size.dart';
import 'package:octadesk_app/features/chat/sections/conversation_detail/conversation_detail.dart';
import 'package:octadesk_app/features/chat/sections/conversation_informations/conversation_informations.dart';
import 'package:octadesk_app/features/chat/sections/conversations_list/conversations_list.dart';
import 'package:octadesk_app/features/chat/sections/new_conversation/new_conversation.dart';
import 'package:octadesk_app/features/chat/sections/no_conversation_selected/no_conversation_selected.dart';
import 'package:octadesk_app/features/chat/sections/no_conversation_selected/no_conversation_selected_side_panel.dart';
import 'package:octadesk_app/features/chat/sections/search_conversation/search_conversation.dart';
import 'package:octadesk_app/features/chat/providers/conversations_provider.dart';
import 'package:octadesk_app/features/chat/providers/new_conversation_provider.dart';
import 'package:octadesk_app/features/chat/providers/search_conversation_provider.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:provider/provider.dart';

class ChatModuleContent extends StatefulWidget {
  const ChatModuleContent({Key? key}) : super(key: key);

  @override
  State<ChatModuleContent> createState() => _ChatModuleContentState();
}

class _ChatModuleContentState extends State<ChatModuleContent> {
  @override
  Widget build(BuildContext context) {
    var conversationProvider = Provider.of<ConversationsProvider>(context);

    var mediaQuery = MediaQuery.of(context);
    var isMobile = mediaQuery.size.width < ScreenSize.md;

    /// Conteúdo do detalhe
    Widget content() {
      return conversationProvider.currentConversation == null

          // Caso não tenha nenhuma conversa selecionada
          ? const NoConversationSelected()

          // Detalhe da conversa
          : ChangeNotifierProvider.value(
              value: conversationProvider.currentConversation,
              child: const ConversationDetail(),
            );
    }

    /// Conteúdo da listagem
    Widget listPanelContent() {
      //
      // Caso container de busca esteja aberto
      if (conversationProvider.searchConversationsPanelOpened) {
        return ChangeNotifierProvider(
          create: (context) => SearchConversationProvider(
            backButtonCallback: () => conversationProvider.searchConversationsPanelOpened = false,
          ),
          child: const SearchConversation(),
        );
      }

      // Caso container de iniciar nova conversa esteja aberto
      if (conversationProvider.newConversationPanelOpened) {
        return ChangeNotifierProvider(
          create: (context) => NewConversationProvider(
            roomCreationCallback: conversationProvider.selectConversation,
            backButtonCallback: () => conversationProvider.newConversationPanelOpened = false,
          ),
          child: const NewConversation(),
        );
      }

      // Listagem de conversas
      return ConversationsList(
        actions: [
          // Botão de buscar conversas
          OctaIconButton(
            onPressed: () => conversationProvider.searchConversationsPanelOpened = true,
            icon: AppIcons.search,
            iconSize: AppSizes.s07,
            size: AppSizes.s08,
          ),
          const SizedBox(width: AppSizes.s02),

          // Iniciar nova conversa
          OctaIconButton(
            onPressed: () => conversationProvider.newConversationPanelOpened = true,
            icon: AppIcons.add,
            iconSize: AppSizes.s07,
            size: AppSizes.s08,
          ),
        ],
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: Colors.grey.shade200,
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              //
              // Conteúdo principal
              Positioned.fill(
                child: Row(
                  children: [
                    //
                    // Listagem de conversas
                    Container(
                      color: Colors.white,
                      width: isMobile ? mediaQuery.size.width : 320,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        switchInCurve: const Interval(.6, 1, curve: Curves.ease),
                        switchOutCurve: const Interval(.6, 1, curve: Curves.ease),
                        child: listPanelContent(),
                      ),
                    ),

                    // Conteúdo
                    if (!isMobile) ...[
                      VerticalDivider(width: 1, color: AppColors.info.shade200),
                      Expanded(
                        child: AnimatedSwitcher(
                          // Transição
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: ScaleTransition(
                                scale: Tween<double>(begin: .98, end: 1).animate(animation),
                                child: child,
                              ),
                            );
                          },
                          duration: const Duration(milliseconds: 400),
                          switchInCurve: const Interval(.6, 1, curve: Curves.ease),
                          switchOutCurve: const Interval(.6, 1, curve: Curves.ease),

                          // Conteúdo
                          child: content(),
                        ),
                      ),

                      /// Painel lateral
                      if (mediaQuery.size.width > ScreenSize.xxl)
                        Container(
                          padding: const EdgeInsets.only(left: AppSizes.s03),
                          width: 260,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            child: conversationProvider.currentConversation == null
                                ? const NoConversationSelectSidePanel()
                                : ChangeNotifierProvider.value(
                                    value: conversationProvider.currentConversation,
                                    child: const ConversationInformations(),
                                  ),
                          ),
                        ),
                    ]
                  ],
                ),
              ),
              if (isMobile)

                /// Detalhe da conversa no mobile
                AnimatedPositioned(
                  top: conversationProvider.currentConversationOpened ? 0 : constraints.maxHeight,
                  left: 0,
                  right: 0,
                  height: constraints.maxHeight,
                  curve: Curves.ease,
                  duration: const Duration(milliseconds: 500),
                  child: content(),
                ),
            ],
          ),
        );
      },
    );
  }
}
