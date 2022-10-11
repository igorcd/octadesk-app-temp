import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/features/chat/providers/chat_detail_provider.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/components/messages/chat_event.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/components/messages/chat_message.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/components/messages/chat_time.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/includes/chat_skeleton.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_core/models/index.dart';
import 'package:octadesk_core/models/message/message_paginator_model.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ChatBody extends StatelessWidget {
  final RoomModel? room;
  final bool canQuoteMessage;
  const ChatBody({required this.room, this.canQuoteMessage = true, super.key});

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('HH:mm');
    ChatDetailProvider chatProvider = Provider.of(context);

    return StreamBuilder<MessagePaginatorModel?>(
      stream: chatProvider.messagesStream,
      builder: (context, snapshot) {
        Widget content;

        // Erro
        if (snapshot.hasError) {
          content = OctaErrorContainer(subtitle: snapshot.error.toString());
        }

        // Caso esteja carregando
        else if (room == null || snapshot.data is! MessagePaginatorModel || snapshot.connectionState == ConnectionState.done) {
          content = const ChatSkeleton();
        }

        // Conteúdo
        else {
          content = LayoutBuilder(
            builder: (context, constraints) {
              var messages = snapshot.data!.messages;
              var isLgScreen = constraints.maxWidth > 640;

              return SlidableAutoCloseBehavior(
                child: NotificationListener<ScrollEndNotification>(
                  onNotification: (ScrollEndNotification notification) {
                    if (notification.metrics.atEdge) {
                      if (notification.metrics.pixels > 0) {
                        chatProvider.paginate(context, direction: 1);
                      } else {
                        chatProvider.paginate(context, direction: -1);
                      }
                    }
                    return true;
                  },
                  child: ScrollablePositionedList.separated(
                    key: const ValueKey("ScrollList"),
                    reverse: true,
                    itemScrollController: chatProvider.scrollController,
                    itemPositionsListener: chatProvider.itemPositionsListener,
                    itemCount: messages.isEmpty ? 0 : messages.length + 1,
                    padding: EdgeInsets.only(
                      top: AppSizes.s05,
                      bottom: AppSizes.s03,
                      left: isLgScreen ? AppSizes.s03 : 0,
                      right: isLgScreen ? AppSizes.s03 : 0,
                    ),
                    separatorBuilder: (c, i) {
                      var nextMessage = messages[i];
                      var prevMessage = messages.length - 1 == i ? null : messages[i + 1];
                      var showDate = prevMessage == null || !DateUtils.isSameDay(nextMessage.time, prevMessage.time);

                      if (showDate) {
                        return ChatTime(nextMessage.time);
                      }
                      return const SizedBox.shrink();
                    },
                    itemBuilder: (context, i) {
                      if (i == messages.length) {
                        return const SizedBox.shrink();
                      }

                      // Mensagem
                      var currentMessage = messages[i];

                      // Próxima mensagem
                      var nextMessage = i == 0 ? null : messages[i - 1];

                      // Mensagem anterior
                      var prevMessage = i == messages.length - 1 ? null : messages[i + 1];

                      // Verificar se tem um evento
                      var events = room!.events.where((e) {
                        var isAfterCurrentMessage = e.time.isAfter(currentMessage.time);
                        var isBeforeNextMessage = nextMessage == null || e.time.isBefore(nextMessage.time);
                        return isAfterCurrentMessage && isBeforeNextMessage;
                      });

                      // Mostrar relógio
                      var showClock = nextMessage == null ||
                          nextMessage.user.id != currentMessage.user.id ||
                          nextMessage.time.toIso8601String().substring(0, 16) != currentMessage.time.toIso8601String().substring(0, 16);

                      var prevMessageInDifferentTime =
                          prevMessage == null || prevMessage.time.toIso8601String().substring(0, 16) != currentMessage.time.toIso8601String().substring(0, 16);

                      // Mostrar o nome
                      var showName = prevMessageInDifferentTime || prevMessage.user.name != currentMessage.user.name || prevMessage.user.id != currentMessage.user.id;

                      // É uma mensagem enviada
                      var sended = !currentMessage.fromClient;

                      // Ações
                      var actions = ActionPane(
                        extentRatio: isLgScreen ? .15 : .3,
                        motion: const DrawerMotion(),
                        children: [
                          // Reponser mensagem
                          if (canQuoteMessage)
                            OctaSlidableAction(
                              icon: AppIcons.reply,
                              onPressed: () => chatProvider.quoteMessage(currentMessage),
                            ),

                          // Copiar para o clipboard
                          OctaSlidableAction(
                            icon: AppIcons.copy,
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: "[${currentMessage.time.toIso8601String()}] ${currentMessage.user.name}: ${currentMessage.comment}"));
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Texto copiado para a área de transferência.")));
                            },
                          ),
                        ],
                      );

                      return AnimatedContainer(
                        key: ValueKey(currentMessage.key),
                        duration: const Duration(milliseconds: 300),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Slidable(
                              key: ValueKey(messages.length - i),
                              groupTag: "0",
                              startActionPane: sended ? null : actions,
                              endActionPane: sended ? actions : null,
                              child: ChatMessage(
                                onQuotedMessageTap: chatProvider.jumpToQuotedMessage,
                                showName: showName,
                                first: prevMessage == null || prevMessage.user.name != currentMessage.user.name,
                                sended: sended,
                                showClock: showClock,
                                time: formatter.format(currentMessage.time),
                                message: currentMessage,
                              ),
                            ),
                            ...events.map((e) => ChatEvent(event: e))
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          child: content,
        );
      },
    );
  }
}
