import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/components/octa_pagination_indicator.dart';
import 'package:octadesk_app/features/chat/providers/closed_conversations_provider.dart';
import 'package:octadesk_app/features/chat/providers/conversations_provider.dart';
import 'package:octadesk_app/features/chat/sections/conversations_list/components/conversation_list_item.dart';
import 'package:octadesk_app/features/chat/sections/conversations_list/components/conversation_list_skeleton.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_conversation/octadesk_conversation.dart';
import 'package:octadesk_core/octadesk_core.dart';
import 'package:provider/provider.dart';

class ClosedConversations extends StatefulWidget {
  const ClosedConversations({super.key});

  @override
  State<ClosedConversations> createState() => _ClosedConversationsState();
}

class _ClosedConversationsState extends State<ClosedConversations> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    ClosedConversationsProvider closedConversationsProvider = Provider.of(context);
    ConversationsProvider conversationsProvider = Provider.of(context);

    return Stack(
      children: [
        //
        // Conteúdo
        Positioned.fill(
          child: StreamBuilder<List<RoomListModel>?>(
            stream: closedConversationsProvider.closedRoomsStream,
            builder: (context, snapshot) {
              Widget child;

              // Caso de erro
              if (snapshot.hasError) {
                child = OctaErrorContainer(
                  subtitle: "Não foi possível carregar as conversas, por favor, tente novamente em breve",
                  error: snapshot.error.toString(),
                  onTryAgain: () => closedConversationsProvider.refresh(clearStream: true),
                );
              }

              // Loading
              else if (!snapshot.hasData) {
                child = const ConversationListSkeleton();
              }

              // Nenhuma conversa
              else if (snapshot.data!.isEmpty) {
                child = Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(AppSizes.s02),
                  child: OctaText.headlineLarge(
                    "Sem conversas por aqui ainda",
                    textAlign: TextAlign.center,
                  ),
                );
              }

              // Conteúdo
              else {
                child = NotificationListener<ScrollEndNotification>(
                  onNotification: (notification) {
                    var atEnd = notification.metrics.pixels > 0 && notification.metrics.atEdge;
                    var atStart = notification.metrics.pixels < 100 && notification.metrics.atEdge;

                    if (atEnd) {
                      closedConversationsProvider.paginate();
                    } else if (atStart) {
                      closedConversationsProvider.clearPagination();
                    }
                    return true;
                  },
                  child: RefreshIndicator(
                    onRefresh: () => closedConversationsProvider.refresh(),
                    child: ListView.separated(
                      controller: _scrollController,
                      itemCount: snapshot.data!.length,
                      separatorBuilder: (c, i) => const Divider(height: 1, thickness: 1, color: AppColors.gray200),
                      itemBuilder: (context, index) {
                        var room = snapshot.data![index];
                        return ConversationListItem(
                          room,
                          onPressed: () => conversationsProvider.selectConversation(room),
                          selected: conversationsProvider.currentConversation?.roomKey == room.key,
                        );
                      },
                    ),
                  ),
                );
              }

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: child,
              );
            },
          ),
        ),
        OctaPaginationIndication(loading: closedConversationsProvider.paginating)
      ],
    );
  }
}
