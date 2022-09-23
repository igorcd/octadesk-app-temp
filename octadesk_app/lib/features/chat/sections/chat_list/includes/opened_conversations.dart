import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/components/octa_search_sliver_button.dart';
import 'package:octadesk_app/features/chat/store/chat_store.dart';
import 'package:octadesk_app/features/chat/sections/chat_list/components/conversation_list_item.dart';
import 'package:octadesk_app/features/chat/sections/chat_list/components/conversation_list_skeleton.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_core/octadesk_core.dart';
import 'package:provider/provider.dart';

class OpenedConversations extends StatelessWidget {
  const OpenedConversations({super.key});

  @override
  Widget build(BuildContext context) {
    ChatStore provider = Provider.of(context);

    return StreamBuilder<RoomPaginationModel?>(
      stream: provider.roomsListStream,
      builder: (context, snapshot) {
        Widget child;

        // Caso de erro
        if (snapshot.hasError) {
          child = OctaErrorContainer(
            subtitle: "Não foi possível carregar as conversas, por favor, tente novamente em breve",
            error: snapshot.error.toString(),
          );
        }

        // Loading
        else if (!snapshot.hasData) {
          child = const ConversationListSkeleton();
        }

        // Nenhuma conversa
        else if (snapshot.data!.rooms.isEmpty) {
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
                if (notification.metrics.pixels > 0 && notification.metrics.atEdge) {
                  print("PAGINAR");
                }
                return true;
              },
              child: CustomScrollView(
                slivers: [
                  OctaSearchSliverButton(),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      var room = snapshot.data!.rooms[index];
                      return ConversationListItem(
                        room,
                        onPressed: () => provider.selectConversation(room),
                        selected: provider.currentConversation?.roomKey == room.key,
                      );
                    }, childCount: snapshot.data!.rooms.length),
                  )
                ],
              )
              // child: ListView.separated(
              //   controller: _scrollController,
              //   itemCount: snapshot.data!.rooms.length,
              //   separatorBuilder: (c, i) => Divider(height: 1, thickness: 1, color: AppColors.info.shade200),
              //   itemBuilder: (context, index) {
              //     var room = snapshot.data!.rooms[index];
              //     return ConversationListItem(
              //       room,
              //       onPressed: () => provider.selectConversation(room),
              //       selected: provider.currentConversation?.roomKey == room.key,
              //     );
              //   },
              // ),
              );
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: child,
        );
      },
    );
  }
}
