import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/components/octa_pagination_indicator.dart';
import 'package:octadesk_app/features/chat/sections/chat_list/components/conversation_list_skeleton.dart';
import 'package:octadesk_app/features/contacts/providers/contact_list_provider.dart';
import 'package:octadesk_app/features/contacts/sections/contact_list/components/contact_list_item.dart';
import 'package:octadesk_app/features/contacts/store/contacts_store.dart';
import 'package:octadesk_core/octadesk_core.dart';
import 'package:provider/provider.dart';

class Contacts extends StatelessWidget {
  const Contacts({super.key});

  @override
  Widget build(BuildContext context) {
    ContactsStore contactStore = Provider.of(context);
    ContactListProvider contactListProvider = Provider.of(context);

    return StreamBuilder<List<ContactListModel>?>(
      stream: contactListProvider.contactsStream,
      builder: (context, snapshot) {
        Widget child;

        // Caso de erro
        if (snapshot.hasError) {
          child = OctaErrorContainer(
            subtitle: "Não foi possível carregar os contatos, por favor, tente novamente em breve",
            error: snapshot.error.toString(),
            onTryAgain: () => contactListProvider.refreshContacts(),
          );
        }

        // Loading
        else if (!snapshot.hasData) {
          child = const ConversationListSkeleton();
        }

        // Conteúdo
        else {
          child = NotificationListener<ScrollEndNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels > 0 && notification.metrics.atEdge) {
                contactListProvider.paginate();
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
                        onTextChange: contactListProvider.searchContact,
                      ),

                      if (snapshot.data?.isEmpty == true) const OctaEmptySliver(text: "Nenhum contato encontado"),

                      // Lista de contatos
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            var contact = snapshot.data![index];
                            return ContactListItem(
                              contact,
                              onPressed: () => contactStore.selectContact(contact.id),
                              selected: contactStore.selectedContactId == contact.id,
                            );
                          },
                          childCount: snapshot.data!.length,
                        ),
                      )
                    ],
                  ),
                ),

                // Indicador de paginação
                OctaPaginationIndication(loading: contactListProvider.paginating)
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
