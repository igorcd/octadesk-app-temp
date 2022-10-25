import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/features/contacts/providers/contact_detail_provider.dart';
import 'package:octadesk_app/features/contacts/sections/contact_detail/contact_detail.dart';
import 'package:octadesk_app/features/contacts/sections/contact_list/contacts_list.dart';
import 'package:octadesk_app/features/contacts/sections/no_contact_selected/no_contact_selected.dart';
import 'package:octadesk_app/features/contacts/store/contacts_store.dart';
import 'package:octadesk_app/resources/app_sizes.dart';
import 'package:provider/provider.dart';

class ContactsFeature extends StatelessWidget {
  const ContactsFeature({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ContactsStore contactsStore = Provider.of(context);
    const contactsList = ContactsList();

    Widget content() {
      return FutureBuilder<ContactDetailProvider?>(
        future: contactsStore.contactDetailFuture,
        builder: (context, snapshot) {
          Widget child;

          // Nenhum contato selecionado
          if (contactsStore.contactDetailFuture == null) {
            child = const NoContactSelected();
          }

          // Se tem erro
          else if (snapshot.hasError) {
            child = OctaErrorContainer(
              subtitle: "Não foi possível carregar as informações do contato, tente novamente em breve",
              error: snapshot.error?.toString(),
            );
          }

          // Carregando
          else if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
            child = const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Detalhe do contato
          else {
            child = ChangeNotifierProvider.value(
              value: snapshot.data,
              child: const ContactDetail(),
            );
          }

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            switchInCurve: const Interval(.6, 1, curve: Curves.ease),
            switchOutCurve: const Interval(.6, 1, curve: Curves.ease),
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: Tween<double>(begin: .95, end: 1).animate(animation),
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            child: child,
          );
        },
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.horizontal(left: Radius.circular(AppSizes.s08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            width: 340,
            child: contactsList,
          ),
          const VerticalDivider(indent: 1, endIndent: 1),

          // Conteúdo principal
          Expanded(
            child: content(),
          ),
        ],
      ),
    );
  }
}
