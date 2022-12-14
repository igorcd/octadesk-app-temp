import 'package:flutter/material.dart';
import 'package:octadesk_app/features/chat/sections/conversation_detail/components/messages/chat_message_attachments_container.dart';
import 'package:octadesk_app/features/chat/sections/conversation_detail/components/messages/chat_message_content.dart';
import 'package:octadesk_app/features/chat/sections/conversation_detail/components/messages/chat_message_quoted.dart';
import 'package:octadesk_app/features/chat/sections/conversation_detail/components/messages/chat_story.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_core/models/message/message_model.dart';

class ChatMessageReceived extends StatelessWidget {
  final void Function(String key) onQuotedMessageTap;
  final bool first;
  final MessageModel message;
  final double maxContainerWidth;
  final String time;
  final bool showName;
  final bool showClock;

  const ChatMessageReceived({
    required this.onQuotedMessageTap,
    required this.showClock,
    required this.showName,
    required this.message,
    required this.first,
    required this.maxContainerWidth,
    required this.time,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Decoration do container
    BoxDecoration getDecoration(bool trimBorder) {
      return BoxDecoration(
        color: AppColors.gray100,
        border: Border.all(color: AppColors.gray300),
        boxShadow: const [AppShadows.s200],
        borderRadius: BorderRadius.only(
          topLeft: trimBorder ? const Radius.circular(AppSizes.s00_5) : const Radius.circular(AppSizes.s03),
          topRight: const Radius.circular(AppSizes.s03),
          bottomLeft: const Radius.circular(AppSizes.s03),
          bottomRight: const Radius.circular(AppSizes.s03),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showName)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.s02, left: AppSizes.s00_5),
            child: Text(
              message.user.name,
              style: const TextStyle(color: AppColors.gray800, fontWeight: FontWeight.bold, fontSize: AppSizes.s03),
            ),
          ),

        if (message.quotedStory != null) ChatStory(message.quotedStory!),

        //

        // Attachments
        if (message.attachments.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.s01),
            child: Container(
              constraints: BoxConstraints(maxWidth: maxContainerWidth),
              decoration: getDecoration(first),
              child: ChatMessageAttachmentsContainer(
                attachments: message.attachments,
              ),
            ),
          ),

        // Conte??do
        if (message.comment.isNotEmpty || message.quotedMessage != null)
          Container(
            constraints: BoxConstraints(maxWidth: maxContainerWidth),
            decoration: getDecoration(first && message.attachments.isEmpty),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //
                // Mesagem citada
                message.quotedMessage == null
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: EdgeInsets.only(
                          top: AppSizes.s01,
                          left: AppSizes.s01,
                          right: AppSizes.s01,
                          bottom: message.comment.isEmpty ? AppSizes.s01 : 0,
                        ),
                        child: ChatMessageQuoted(
                          onTap: () => onQuotedMessageTap(message.quotedMessage!.key),
                          message: message.quotedMessage!,
                        ),
                      ),

                // Conte??do
                Padding(
                  padding: const EdgeInsets.all(AppSizes.s04),
                  child: ChatMessageContent(message.comment),
                ),
              ],
            ),
          ),

        // Hora da mensagem
        if (showClock)
          Padding(
            padding: const EdgeInsets.only(top: AppSizes.s01_5),
            child: Text(
              time,
              style: const TextStyle(fontSize: AppSizes.s03, fontFamily: "NotoSans"),
            ),
          )
      ],
    );
  }
}
