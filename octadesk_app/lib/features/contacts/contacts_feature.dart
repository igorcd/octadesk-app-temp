import 'package:flutter/material.dart';
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
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              switchInCurve: Interval(.6, 1, curve: Curves.ease),
              switchOutCurve: Interval(.6, 1, curve: Curves.ease),
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: Tween<double>(begin: .95, end: 1).animate(animation),
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              child: contactsStore.selectedContact == null ? const NoContactSelected() : const ContactDetail(),
            ),
          ),
        ],
      ),
    );
  }
}
