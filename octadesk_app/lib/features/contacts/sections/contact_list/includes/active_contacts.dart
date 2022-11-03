import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/components/octa_pagination_indicator.dart';
import 'package:octadesk_app/features/chat/sections/chat_list/components/conversation_list_skeleton.dart';
import 'package:octadesk_app/features/contacts/sections/contact_list/components/contact_list_item.dart';
import 'package:octadesk_app/features/contacts/store/contacts_store.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_core/octadesk_core.dart';
import 'package:provider/provider.dart';

class ActiveContacts extends StatelessWidget {
  const ActiveContacts({super.key});

  @override
  Widget build(BuildContext context) {
    ContactsStore provider = Provider.of(context);

    return StreamBuilder<List<ContactListModel>?>(
      stream: provider.contactsStream,
      builder: (context, snapshot) {
        Widget child;

        // Caso de erro
        if (snapshot.hasError) {
          child = OctaErrorContainer(
            subtitle: "Não foi possível carregar os contatos, por favor, tente novamente em breve",
            error: snapshot.error.toString(),
            onTryAgain: () => provider.refreshContacts(),
          );
        }

        // Loading
        else if (!snapshot.hasData) {
          child = const ConversationListSkeleton();
        }

        // Nenhuma contato
        else if (snapshot.data!.isEmpty) {
          child = Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(AppSizes.s02),
            child: OctaText.headlineLarge(
              "Sem contatos por aqui ainda",
              textAlign: TextAlign.center,
            ),
          );
        }

        // Conteúdo
        else {
          child = NotificationListener<ScrollEndNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels > 0 && notification.metrics.atEdge) {
                provider.paginate();
              }
              return true;
            },
            child: Stack(
              children: [
                // Lista
                Positioned.fill(
                  child: CustomScrollView(
                    slivers: [
                      // Busca
                      OctaSearchSliver(
                        loading: snapshot.connectionState == ConnectionState.waiting,
                        onTextChange: provider.searchContact,
                      ),

                      // Lista de contatos
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            var contact = snapshot.data![index];
                            return ContactListItem(
                              contact,
                              onPressed: () => provider.selectContact(contact.id),
                              selected: provider.selectedConversationId == contact.id,
                            );
                          },
                          childCount: snapshot.data!.length,
                        ),
                      )
                    ],
                  ),
                ),

                // Indicador de paginação
                OctaPaginationIndication(loading: provider.paginating)
              ],
            ),
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
