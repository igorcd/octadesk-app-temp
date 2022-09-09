import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:octadesk_app/components/octa_slidable_action.dart';
import 'package:octadesk_app/features/chat/sections/conversation_detail/components/messages/chat_event.dart';
import 'package:octadesk_app/features/chat/sections/conversation_detail/components/messages/chat_message.dart';
import 'package:octadesk_app/features/chat/sections/conversation_detail/components/messages/chat_time.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_core/octadesk_core.dart';
import 'package:collection/collection.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ChatBody extends StatefulWidget {
  final void Function(MessageModel message)? onQuoteMessage;
  final ItemScrollController scrollController;
  final ItemPositionsListener? itemPositionsListener;
  final RoomModel room;

  const ChatBody({
    required this.scrollController,
    this.itemPositionsListener,
    this.onQuoteMessage,
    required this.room,
    Key? key,
  }) : super(key: key);

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  int highlightIndex = -1;

  void _jumpToQuotedMessage(String key) {
    var el = widget.room.messages.firstWhereOrNull((element) => element.key == key);
    if (el != null) {
      var index = widget.room.messages.indexOf(el);
      widget.scrollController.jumpTo(index: index > 0 ? index - 1 : index);

      // Destacar a mensagem
      Timer(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            highlightIndex = index;
          });

          Timer(const Duration(milliseconds: 350), () {
            if (mounted) {
              setState(() {
                highlightIndex = -1;
              });
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('HH:mm');

    return LayoutBuilder(builder: (context, constraints) {
      var isLgScreen = constraints.maxWidth > 640;

      return SlidableAutoCloseBehavior(
        child: ScrollablePositionedList.separated(
          reverse: true,
          itemScrollController: widget.scrollController,
          itemPositionsListener: widget.itemPositionsListener,
          itemCount: widget.room.messages.isEmpty ? 0 : widget.room.messages.length + 1,
          padding: EdgeInsets.only(
            top: AppSizes.s05,
            bottom: AppSizes.s03,
            left: isLgScreen ? AppSizes.s03 : 0,
            right: isLgScreen ? AppSizes.s03 : 0,
          ),
          separatorBuilder: (c, i) {
            var nextMessage = widget.room.messages[i];
            var prevMessage = widget.room.messages.length - 1 == i ? null : widget.room.messages[i + 1];
            var showDate = prevMessage == null || !DateUtils.isSameDay(nextMessage.time, prevMessage.time);

            if (showDate) {
              return ChatTime(nextMessage.time);
            }
            return const SizedBox.shrink();
          },
          itemBuilder: (context, i) {
            if (i == widget.room.messages.length) {
              return const SizedBox.shrink();
            }

            // Mensagem
            var currentMessage = widget.room.messages[i];

            // Próxima mensagem
            var nextMessage = i == 0 ? null : widget.room.messages[i - 1];

            // Mensagem anterior
            var prevMessage = i == widget.room.messages.length - 1 ? null : widget.room.messages[i + 1];

            // Verificar se tem um evento
            var events = widget.room.events.where((e) {
              var isAfterCurrentMessage = e.time.isAfter(currentMessage.time);
              var isBeforeNextMessage = nextMessage == null || e.time.isBefore(nextMessage.time);
              return isAfterCurrentMessage && isBeforeNextMessage;
            });

            // Mostrar relógio
            var showClock = nextMessage == null ||
                nextMessage.user.id != currentMessage.user.id ||
                nextMessage.time.toIso8601String().substring(0, 16) != currentMessage.time.toIso8601String().substring(0, 16);

            var prevMessageInDifferentTime = prevMessage == null || prevMessage.time.toIso8601String().substring(0, 16) != currentMessage.time.toIso8601String().substring(0, 16);

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
                if (widget.onQuoteMessage != null) OctaSlidableAction(icon: AppIcons.reply, onPressed: () => widget.onQuoteMessage!(currentMessage)),

                // Copiar para o clipboard
                OctaSlidableAction(
                  icon: AppIcons.copy,
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: currentMessage.comment));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Texto copiado para a área de transferência.")));
                  },
                ),
              ],
            );

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              color: highlightIndex == i ? AppColors.gray100 : Colors.white,
              child: Column(
                children: [
                  Slidable(
                    key: ValueKey(widget.room.messages.length - i),
                    groupTag: "0",
                    startActionPane: sended ? null : actions,
                    endActionPane: sended ? actions : null,
                    child: ChatMessage(
                      onQuotedMessageTap: _jumpToQuotedMessage,
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
      );
    });
  }
}
