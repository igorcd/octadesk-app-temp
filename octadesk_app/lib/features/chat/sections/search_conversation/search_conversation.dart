import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/components/octa_separated_sliver_list.dart';
import 'package:octadesk_app/features/chat/providers/search_conversation_provider.dart';
import 'package:octadesk_app/features/chat/sections/chat_list/components/conversation_list_item.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_core/models/index.dart';
import 'package:provider/provider.dart';

class SearchConversation extends StatefulWidget {
  const SearchConversation({Key? key}) : super(key: key);

  @override
  State<SearchConversation> createState() => _SearchConversationState();
}

class _SearchConversationState extends State<SearchConversation> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    // Provider
    var searchConversationProvider = Provider.of<SearchConversationProvider>(context);

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //
          // Header
          SizedBox(
            height: AppSizes.s18,
            child: Row(
              children: [
                OctaIconButton(
                  onPressed: () => searchConversationProvider.backButtonCallback(),
                  icon: AppIcons.arrowBack,
                  iconSize: AppSizes.s06,
                ),
                Expanded(
                  child: OctaText.headlineMedium(
                    "Buscar conversa",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Divider(thickness: 2, height: 2, color: AppColors.info.shade100),

          // Conteúdo
          Expanded(
            child: StreamBuilder<List<RoomListModel>>(
              stream: searchConversationProvider.roomsStream,
              builder: (context, snapshot) {
                return NotificationListener<ScrollEndNotification>(
                  //
                  // Realizar paginação quando chegar no fim da página
                  onNotification: (ScrollEndNotification notification) {
                    if (notification.metrics.axis == Axis.vertical && notification.metrics.pixels > 0 && notification.metrics.atEdge) {
                      searchConversationProvider.paginate();
                    }
                    return true;
                  },
                  child: CustomScrollView(
                    controller: searchConversationProvider.scrollController,
                    slivers: [
                      // Busca
                      OctaSearchSliver(
                        onTextChange: (value) => searchConversationProvider.search(value),
                        loading: searchConversationProvider.loading,
                        filters: [
                          // Buscar por
                          OctaTag(
                            placeholder: "Buscar por: ${searchConversationProvider.searchByLabel}",
                            active: true,
                            onPressed: () => searchConversationProvider.openSearchByDialog(context),
                            icon: AppIcons.angleDown,
                          ),
                          // Status
                          OctaTag(
                            placeholder: searchConversationProvider.statusLabel,
                            active: true,
                            onPressed: () => searchConversationProvider.openStatusDialog(context),
                            icon: AppIcons.angleDown,
                          ),
                          // Operação
                          OctaTag(
                            placeholder: searchConversationProvider.operationLabel,
                            onPressed: () => searchConversationProvider.openOperationModal(context),
                            active: searchConversationProvider.hasOperationFilter,
                            icon: AppIcons.angleDown,
                          ),

                          // Tags
                          OctaTag(
                            placeholder: "Tags",
                            onPressed: () => searchConversationProvider.openTagsDialog(context),
                            active: searchConversationProvider.hasTagsFilter,
                            icon: AppIcons.angleDown,
                          ),

                          // Período
                          OctaTag(
                            placeholder: searchConversationProvider.periodLabel,
                            onPressed: () => searchConversationProvider.openDateDialog(context),
                            active: searchConversationProvider.hasPeriodFilter,
                            icon: AppIcons.angleDown,
                          ),

                          // Canal
                          OctaTag(
                            placeholder: searchConversationProvider.selectedChannelLabel,
                            onPressed: () => searchConversationProvider.openChannelsDialog(context),
                            active: searchConversationProvider.hasChannelFilter,
                            icon: AppIcons.angleDown,
                          ),
                        ],
                      ),

                      // Erro
                      if (snapshot.hasError)
                        SliverToBoxAdapter(
                          child: OctaErrorContainer(
                            subtitle: "Não foi possível carregar os usuários, por favor, tente novamente em breve",
                            error: snapshot.error.toString(),
                          ),
                        )

                      // Caso não tenha dados
                      else if (snapshot.data == null)
                        const OctaEmptySliver(text: "Carregando")

                      // Caso não tenha nenhum usuário
                      else if (snapshot.data!.isEmpty)
                        const SliverToBoxAdapter(
                          child: OctaEmptyContainer(
                            title: "Desculpe, mas não encontramos resultados correspondentes à sua pesquisa",
                            subtitle: "Pesquise novamente usando outros critérios de pesquisa.",
                          ),
                        )

                      // Lista de usuários
                      else
                        OctaSeparatedSliverList(
                          itemCount: snapshot.data!.length,
                          separatorBuilder: (c, i) => const Divider(height: 0),
                          itemBuilder: (context, index) {
                            var room = snapshot.data![index];
                            return ConversationListItem(
                              room,
                              onPressed: () {},
                              selected: false,
                            );
                          },
                        )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
