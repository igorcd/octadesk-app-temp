import 'package:flutter/material.dart';
import 'package:octadesk_app/components/octa_feature_header.dart';
import 'package:octadesk_app/components/octa_feature_title.dart';
import 'package:octadesk_app/features/chat/sections/chat_list/components/conversation_header_tab.dart';
import 'package:octadesk_app/features/contacts/sections/contact_list/include/active_contacts.dart';
import 'package:octadesk_app/features/contacts/store/contacts_store.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:provider/provider.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({super.key});

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> with TickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Header
        OctaFeatureHeader(
          controller: _controller,

          // Título
          title: OctaFeatureTitle(
            text: "Contatos",
            onTap: () {},
          ),

          // Tabs
          tabsBuilder: (context, i) {
            return [
              ConversationHeaderTab(
                label: "Ativos",
                selected: i == 0,
                onTap: () => _controller.animateTo(0),
              ),
              ConversationHeaderTab(
                label: "Inativos",
                selected: i == 1,
                onTap: () => _controller.animateTo(1),
              ),
              const Spacer(),
              ConversationHeaderTab(
                selected: i == 2,
                child: Image.asset(
                  AppIcons.newConversation,
                  color: colorScheme.onSurface,
                  width: AppSizes.s06,
                ),
                onTap: () => _controller.animateTo(2),
              )
            ];
          },
        ),

        // Conteúdo
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: const [
              ActiveContacts(),
              Text("2"),
              Text("3"),
            ],
          ),
        ),
      ],
    );
  }
}
