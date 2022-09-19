import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/features/chat/sections/new_conversation/components/new_conversation_contact_button.dart';
import 'package:octadesk_app/features/chat/providers/new_conversation_provider.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_app/utils/helper_functions.dart';
import 'package:octadesk_core/dtos/contact/contact_list_dto.dart';
import 'package:provider/provider.dart';

class NewConversation extends StatefulWidget {
  const NewConversation({Key? key}) : super(key: key);

  @override
  State<NewConversation> createState() => _NewConversationState();
}

class _NewConversationState extends State<NewConversation> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var newConversationProvider = Provider.of<NewConversationProvider>(context);

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
                  onPressed: () => newConversationProvider.back(),
                  icon: AppIcons.arrowBack,
                  iconSize: AppSizes.s06,
                ),
                Expanded(
                  child: OctaText.headlineMedium(
                    "Nova conversa",
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
            child: StreamBuilder<List<ContactListDTO>>(
              stream: newConversationProvider.usersStream,
              builder: (context, snapshot) {
                return NotificationListener<ScrollEndNotification>(
                  //
                  // Realizar paginação quando chegar no fim da página
                  onNotification: (ScrollEndNotification notification) {
                    if (notification.metrics.pixels > 0 && notification.metrics.atEdge) {
                      newConversationProvider.paginate();
                    }
                    return true;
                  },
                  child: CustomScrollView(
                    controller: newConversationProvider.scrollController,
                    slivers: [
                      // Busca
                      OctaSearchSliver(
                        onTextChange: (value) => newConversationProvider.search(value),
                        loading: newConversationProvider.loading,
                      ),

                      // Adicionar novo usuário
                      SliverToBoxAdapter(
                        child: NewConversationContactButton(onPressed: () {}),
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
                        const OctaEmptySliver(text: "Nenhum contato encontrado")

                      // Lista de usuários
                      else
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            // Contato
                            (context, index) {
                              var contact = snapshot.data![index];

                              // Usuário
                              return OctaListItem(
                                title: contact.name,
                                subtitle: contact.phoneContacts.isNotEmpty
                                    ? setPhoneMaskHelper("${contact.phoneContacts[0].countryCode}${contact.phoneContacts[0].number}") // Telefone
                                    : contact.email, // Email
                                pictureUrl: contact.thumbUrl,
                                showDivider: true,
                                onPressed: () => newConversationProvider.selectUser(contact, context),
                              );
                            },
                            childCount: snapshot.data!.length,
                          ),
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
