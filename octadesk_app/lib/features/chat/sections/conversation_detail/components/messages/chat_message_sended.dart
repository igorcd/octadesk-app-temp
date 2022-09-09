import 'package:flutter/material.dart';
import 'package:octadesk_app/features/chat/sections/conversation_detail/components/messages/chat_message_attachments_container.dart';
import 'package:octadesk_app/features/chat/sections/conversation_detail/components/messages/chat_message_clock.dart';
import 'package:octadesk_app/features/chat/sections/conversation_detail/components/messages/chat_message_content.dart';
import 'package:octadesk_app/features/chat/sections/conversation_detail/components/messages/chat_message_quoted.dart';
import 'package:octadesk_app/features/chat/sections/conversation_detail/components/messages/chat_story.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_core/octadesk_core.dart';

class ChatMessageSended extends StatelessWidget {
  final void Function(String key) onQuotedMessageTap;
  final bool first;
  final MessageModel message;
  final double maxContainerWidth;
  final String time;
  final bool showName;
  final bool showClock;

  const ChatMessageSended({
    required this.onQuotedMessageTap,
    required this.showClock,
    required this.message,
    required this.first,
    required this.showName,
    required this.maxContainerWidth,
    required this.time,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    // Estilização do box
    BoxDecoration getDecoration(bool trinBorder) {
      // Borda
      BoxBorder? border;
      if (message.type == MessageTypeEnum.internal) {
        border = Border.all(color: AppColors.yellow300);
      } else if (message.status == MessageStatusEnum.error) {
        border = Border.all(color: Colors.red);
      } else {
        border = Border.all(color: AppColors.blue200);
      }

      return BoxDecoration(
        color: message.type == MessageTypeEnum.internal ? AppColors.yellow100 : AppColors.blue100,
        border: border,
        boxShadow: const [AppShadows.s200],
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(AppSizes.s03),
          topRight: trinBorder ? const Radius.circular(AppSizes.s00_5) : const Radius.circular(AppSizes.s03),
          bottomLeft: const Radius.circular(AppSizes.s03),
          bottomRight: const Radius.circular(AppSizes.s03),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (showName)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.s02, left: AppSizes.s00_5),
            child: Text(
              message.user.name,
              style: const TextStyle(color: AppColors.gray800, fontWeight: FontWeight.bold, fontSize: AppSizes.s03),
            ),
          ),

        // Story
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

        // Conteúdo
        if (message.comment.isNotEmpty || message.quotedMessage != null)
          Container(
            constraints: BoxConstraints(maxWidth: maxContainerWidth, minHeight: 52),
            decoration: getDecoration(first && message.attachments.isEmpty),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //
                // Mesagem citada
                if (message.quotedMessage != null)
                  Padding(
                    padding: EdgeInsets.only(
                      top: AppSizes.s01,
                      left: AppSizes.s01,
                      right: AppSizes.s01,
                      bottom: message.comment.isEmpty ? AppSizes.s01 : 0,
                    ),
                    child: ChatMessageQuoted(
                      onTap: () => onQuotedMessageTap(message.quotedMessage!.key),
                      message: message.quotedMessage!,
                      maxWidth: maxContainerWidth - 10,
                    ),
                  ),

                // Conteúdo
                if (message.comment.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(AppSizes.s04),

                    // Conteúdo da mensagem
                    child: ChatMessageContent(
                      message.comment,
                      isInternal: message.type == MessageTypeEnum.internal,
                    ),
                  )
              ],
            ),
          ),

        // Botões do bot
        // Botões do bot
        if (message.buttons.isNotEmpty)
          ...message.buttons.map(
            (e) => Container(
              padding: const EdgeInsets.all(AppSizes.s02),
              margin: const EdgeInsets.symmetric(vertical: AppSizes.s01),
              constraints: BoxConstraints(maxWidth: maxContainerWidth),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(240, 246, 253, 1),
                border: Border.all(color: AppColors.blue500),
                borderRadius: const BorderRadius.all(Radius.circular(AppSizes.s03)),
              ),
              child: ChatMessageContent("<b>${message.buttons.indexOf(e) + 1}</b> - $e"),
            ),
          ),

        // Relógio
        if (showClock)
          Padding(
            padding: const EdgeInsets.only(top: AppSizes.s01_5),
            child: ChatMessageClock(
              status: message.status,
              time: time,
            ),
          )
      ],
    );
  }
}
