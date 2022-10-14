import 'package:flutter/material.dart';
import 'package:octadesk_app/components/responsive/responsive_widgets.dart';
import 'package:octadesk_app/features/chat/store/chat_store.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_app/utils/helper_functions.dart';
import 'package:octadesk_app/views/main/components/app_side_panel_group.dart';
import 'package:octadesk_app/views/main/components/app_side_panel_item.dart';
import 'package:octadesk_core/octadesk_core.dart';
import 'package:provider/provider.dart';

class ChatInbox extends StatelessWidget {
  const ChatInbox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ChatStore>(context);
    var colorScheme = Theme.of(context).colorScheme;
    var screenSize = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 1,
            color: screenSize >= ScreenSize.lg ? colorScheme.outline : Colors.transparent,
          ),
        ),
      ),
      child: StreamBuilder<Map<RoomFilterEnum, int>>(
        stream: provider.inboxMessagesCountStream,
        builder: (context, snapshot) {
          // Carregado
          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          }
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.s04, vertical: AppSizes.s07),
            children: [
              // Logo
              Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.s05),
                child: Image.asset(
                  AppImages.appLogo,
                  height: AppSizes.s09_5,
                  color: Theme.of(context).colorScheme.inversePrimary,
                  alignment: Alignment.centerLeft,
                ),
              ),

              // Menu
              AppSidePanelGroup(
                title: "Conversas",
                items: snapshot.data!.entries.map(
                  (e) {
                    return AppSidePanelItem(
                      label: getInboxFilterEnumName(e.key),
                      selected: provider.currentInbox == e.key,
                      onTap: () => provider.changeInbox(e.key),
                      trailing: e.value.toString(),
                    );
                  },
                ).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}
