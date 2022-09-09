import 'package:flutter/cupertino.dart';
import 'package:octadesk_app/features/base_feature/app_side_panel_group.dart';
import 'package:octadesk_app/features/base_feature/app_side_panel_item.dart';
import 'package:octadesk_app/features/chat/providers/conversations_provider.dart';
import 'package:octadesk_app/providers/authentication_provider.dart';
import 'package:octadesk_app/utils/helper_functions.dart';
import 'package:octadesk_conversation/inbox_filters/inbox_filters.dart';
import 'package:octadesk_core/octadesk_core.dart';
import 'package:provider/provider.dart';

class ChatModuleMenu extends StatelessWidget {
  const ChatModuleMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ConversationsProvider>(context);
    var agentId = Provider.of<AuthenticationProvider>(context, listen: false).user!.agentId;

    return StreamBuilder<Map<RoomFilterEnum, int>>(
      stream: provider.inboxMessagesCountStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        return AppSidePanelGroup(
          title: "Conversas",
          items: snapshot.data!.entries.map(
            (e) {
              return AppSidePanelItem(
                label: getInboxFilterEnumName(e.key),
                selected: provider.currentInbox.descriptor == e.key,
                onTap: () => provider.changeInbox(InboxFilters.getFilterByType(e.key, page: 1, agentId: agentId)),
                trailing: e.value.toString(),
              );
            },
          ).toList(),
        );
      },
    );
  }
}
