import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/features/chat/providers/new_chat_provider.dart';
import 'package:octadesk_app/features/chat/sections/chat_list/components/conversation_list_skeleton.dart';
import 'package:octadesk_app/features/chat/sections/new_chat/components/new_contact_button.dart';
import 'package:octadesk_app/utils/helper_functions.dart';
import 'package:octadesk_core/dtos/contact/contact_list_dto.dart';
import 'package:provider/provider.dart';

class NewChat extends StatefulWidget {
  const NewChat({Key? key}) : super(key: key);

  @override
  State<NewChat> createState() => _NewChatState();
}

class _NewChatState extends State<NewChat> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var newChatProvider = Provider.of<NewChatProvider>(context);

    return StreamBuilder<List<ContactListDTO>>(
      stream: newChatProvider.usersStream,
      builder: (context, snapshot) {
        Widget child;

        // Caso de carregamento
        if (snapshot.data == null && !snapshot.hasError) {
          child = const ConversationListSkeleton();
        }
        // Lista de conversas
        else {
          child = NotificationListener<ScrollEndNotification>(
            //
            // Realizar paginação quando chegar no fim da página
            onNotification: (ScrollEndNotification notification) {
              if (notification.metrics.pixels > 0 && notification.metrics.atEdge) {
                newChatProvider.paginate();
              }
              return true;
            },
            child: CustomScrollView(
              controller: newChatProvider.scrollController,
              slivers: [
                // Busca
                OctaSearchSliver(
                  onTextChange: (value) => newChatProvider.search(value),
                  loading: newChatProvider.loading,
                ),

                // Adicionar novo usuário
                SliverToBoxAdapter(
                  child: NewContactButton(onPressed: () {}),
                ),

                // Erro
                if (snapshot.hasError)
                  SliverToBoxAdapter(
                    child: OctaErrorContainer(
                      subtitle: "Não foi possível carregar os usuários, por favor, tente novamente em breve",
                      error: snapshot.error.toString(),
                    ),
                  )
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
                          onPressed: () => newChatProvider.selectUser(contact, context),
                          leading: OctaAvatar(
                            name: contact.name,
                            source: contact.thumbUrl,
                          ),
                        );
                      },
                      childCount: snapshot.data!.length,
                    ),
                  )
              ],
            ),
          );
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: child,
        );
      },
    );
  }
}
