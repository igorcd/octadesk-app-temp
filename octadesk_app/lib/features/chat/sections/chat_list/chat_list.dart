import 'package:flutter/material.dart';
import 'package:octadesk_app/features/chat/providers/closed_conversations_provider.dart';
import 'package:octadesk_app/features/chat/providers/new_chat_provider.dart';
import 'package:octadesk_app/features/chat/sections/chat_list/includes/closed_conversations.dart';
import 'package:octadesk_app/features/chat/sections/chat_list/includes/conversations_header.dart';
import 'package:octadesk_app/features/chat/sections/chat_list/includes/opened_conversations.dart';
import 'package:octadesk_app/features/chat/sections/new_chat/new_chat.dart';
import 'package:octadesk_app/features/chat/store/chat_store.dart';
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
    return Column(children: [
      ConversationsHeader(
        controller: _controller,
      ),
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
    ]);
  }
}
