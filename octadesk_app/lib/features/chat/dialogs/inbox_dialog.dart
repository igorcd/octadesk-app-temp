import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/components/octa_radio_list_tile.dart';
import 'package:octadesk_app/components/octa_skeleton_list.dart';
import 'package:octadesk_app/resources/app_sizes.dart';
import 'package:octadesk_app/utils/helper_functions.dart';
import 'package:octadesk_conversation/octadesk_conversation.dart';
import 'package:octadesk_core/enums/room_filter_enum.dart';

class InboxDialog extends StatefulWidget {
  final RoomFilterEnum currentInbox;
  const InboxDialog({required this.currentInbox, super.key});

  @override
  State<InboxDialog> createState() => _InboxDialogState();
}

class _InboxDialogState extends State<InboxDialog> {
  late RoomFilterEnum _currentInboxTemp;
  final inboxMessageStreamController = OctadeskConversation.instance.getInboxFiltersMessagesCountController();

  @override
  void initState() {
    super.initState();
    _currentInboxTemp = widget.currentInbox;
  }

  @override
  void dispose() {
    inboxMessageStreamController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<Map<RoomFilterEnum, int>?>(
            stream: inboxMessageStreamController.inboxFiltersMessagesStream,
            builder: (context, snapshot) {
              var inboxes = snapshot.data?.entries.toList() ?? [];

              // Caso de erro
              if (snapshot.hasError) {
                return OctaErrorContainer(
                  subtitle: "Não foi possível carregar os dados",
                  error: snapshot.error.toString(),
                );
              }

              // Loading
              if (!snapshot.hasData) {
                return const OctaSkeletonList();
              }

              // Conteúdo
              return ListView.separated(
                itemCount: inboxes.length,
                separatorBuilder: (c, i) => const Divider(),
                itemBuilder: (context, index) {
                  var inbox = inboxes[index];

                  return OctaRadioListTile<RoomFilterEnum>(
                    label: "${getInboxFilterEnumName(inbox.key)} (${inbox.value})",
                    groupValue: _currentInboxTemp,
                    value: inbox.key,
                    onSelect: (value) => setState(() => _currentInboxTemp = value),
                  );
                },
              );
            },
          ),
        ),
        const Divider(),

        // Botão
        Padding(
          padding: const EdgeInsets.all(AppSizes.s04),
          child: OctaButton(onTap: () => Navigator.of(context).pop(_currentInboxTemp), text: "Aplicar"),
        )
      ],
    );
  }
}
