import 'package:flutter/material.dart';
import 'package:octadesk_app/features/chat/sections/chat_list/includes/conversations_header.dart';
import 'package:octadesk_app/features/chat/sections/chat_list/includes/opened_conversations.dart';

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
          children: const [
            OpenedConversations(),
            Text("Tab2"),
            Text("Tab3"),
          ],
        ),
      ),
    ]);
  }
}
