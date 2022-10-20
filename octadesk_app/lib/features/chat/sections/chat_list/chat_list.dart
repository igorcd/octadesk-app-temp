import 'package:flutter/material.dart';
import 'package:octadesk_app/components/octa_feature_header.dart';
import 'package:octadesk_app/components/octa_feature_title.dart';
import 'package:octadesk_app/components/responsive/responsive_widgets.dart';
import 'package:octadesk_app/features/chat/providers/closed_conversations_provider.dart';
import 'package:octadesk_app/features/chat/providers/new_chat_provider.dart';
import 'package:octadesk_app/features/chat/sections/chat_list/components/conversation_header_tab.dart';
import 'package:octadesk_app/features/chat/sections/chat_list/includes/closed_conversations.dart';
import 'package:octadesk_app/features/chat/sections/chat_list/includes/opened_conversations.dart';
import 'package:octadesk_app/features/chat/sections/new_chat/new_chat.dart';
import 'package:octadesk_app/features/chat/store/chat_store.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_app/utils/helper_functions.dart';
import 'package:provider/provider.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> with TickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Header
        OctaFeatureHeader(
          controller: _controller,

          // Título
          title: MediaQuery.of(context).size.width < ScreenSize.xl
              ? Consumer<ChatStore>(
                  builder: (context, value, child) {
                    return OctaFeatureTitle(
                      text: value.currentInbox != null ? getInboxFilterEnumName(value.currentInbox!) : "Carregando",
                      onTap: () => value.openInboxDialog(context),
                    );
                  },
                )
              : null,

          // Tabs
          tabsBuilder: (context, i) {
            return [
              ConversationHeaderTab(
                label: "Abertas",
                selected: i == 0,
                onTap: () => _controller.animateTo(0),
              ),
              ConversationHeaderTab(
                label: "Encerradas",
                selected: i == 1,
                onTap: () => _controller.animateTo(1),
              ),
              const Spacer(),
              ConversationHeaderTab(
                selected: i == 2,
                child: Image.asset(
                  AppIcons.newConversation,
                  color: colorScheme.onSurface,
                  width: AppSizes.s06,
                ),
                onTap: () => _controller.animateTo(2),
              )
            ];
          },
        ),

        // Conteúdo
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: [
              // Conversas abertas
              const OpenedConversations(),

              // Conversas fechadas
              ChangeNotifierProvider(
                create: (context) => ClosedConversationsProvider(),
                child: const ClosedConversations(),
              ),

              // Nova conversa
              ChangeNotifierProvider(
                create: (context) => NewChatProvider(Provider.of<ChatStore>(context, listen: false)),
                child: const NewChat(),
              )
            ],
          ),
        ),
      ],
    );
  }
}
