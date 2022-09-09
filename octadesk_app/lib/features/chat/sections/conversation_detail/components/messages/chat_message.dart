import 'package:flutter/material.dart';
import 'package:octadesk_app/features/chat/sections/conversation_detail/components/messages/chat_message_received.dart';
import 'package:octadesk_app/features/chat/sections/conversation_detail/components/messages/chat_message_sended.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_core/octadesk_core.dart';

class ChatMessage extends StatelessWidget {
  final void Function(String key) onQuotedMessageTap;
  final bool first;
  final bool sended;
  final bool showClock;
  final MessageModel message;
  final String time;
  final bool showName;

  const ChatMessage({
    required this.onQuotedMessageTap,
    required this.showName,
    required this.first,
    required this.sended,
    required this.showClock,
    required this.message,
    required this.time,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isLgScreen = MediaQuery.of(context).size.width > 1024;

    final double maxContainerWidth = isLgScreen ? 600 : 300;
    return Container(
      width: double.infinity,
      // Padding
      padding: EdgeInsets.only(left: AppSizes.s05, right: AppSizes.s05, bottom: showClock ? AppSizes.s03 : AppSizes.s01),
      child: sended
          ? ChatMessageSended(
              onQuotedMessageTap: onQuotedMessageTap,
              time: time,
              first: first,
              maxContainerWidth: maxContainerWidth,
              message: message,
              showName: showName,
              showClock: showClock,
            )
          : ChatMessageReceived(
              onQuotedMessageTap: onQuotedMessageTap,
              showName: showName,
              showClock: showClock,
              time: time,
              first: first,
              maxContainerWidth: maxContainerWidth,
              message: message,
            ),
    );
  }
}
