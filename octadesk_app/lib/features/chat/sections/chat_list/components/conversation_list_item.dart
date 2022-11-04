import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_core/octadesk_core.dart';

class ConversationListItem extends StatelessWidget {
  final RoomListModel room;
  final bool selected;
  final void Function() onPressed;
  const ConversationListItem(this.room, {required this.onPressed, required this.selected, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    String formatAgentName(String? agentName) {
      var name = agentName?.trim();

      if (name == null || name.isEmpty) {
        return "";
      }

      var parts = name.split(' ');
      if (parts.length == 1) {
        return parts[0];
      }

      return "${parts[0]} ${parts[parts.length - 1].substring(0, 1)}.";
    }

    String formattedTime() {
      final f = DateFormat('HH\'h\'mm');
      return f.format(room.lastMessageTime);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.s02),
      height: AppSizes.s17,
      child: Material(
        borderRadius: BorderRadius.circular(AppSizes.s03_5),
        clipBehavior: Clip.hardEdge,
        color: selected ? colorScheme.background.withOpacity(.8) : Colors.transparent,

        // Botão
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.s02, vertical: AppSizes.s02),
            child: Row(
              children: [
                //
                // Avatar do usuário
                OctaAvatar(
                  size: AppSizes.s13,
                  name: room.user.name,
                  source: room.user.thumbUrl,
                  badge: OctaSocialMediaBadge(room.isWhatsAppOficial ? ChatChannelEnum.whatsappOficial : room.channel),
                ),
                const SizedBox(width: AppSizes.s04),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //
                      // Nome do usuário
                      Text(
                        room.user.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: room.hasNewMessage ? textTheme.titleLarge : textTheme.titleMedium,
                      ),

                      // Última mensagem
                      OctaText.titleSmall(
                        room.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    room.agent != null
                        //
                        // Container de nome do agente
                        ? Container(
                            constraints: const BoxConstraints(maxWidth: 80),
                            height: AppSizes.s03_5,
                            padding: const EdgeInsets.symmetric(horizontal: AppSizes.s01_5),
                            decoration: BoxDecoration(color: colorScheme.outline, borderRadius: BorderRadius.circular(AppSizes.s10)),

                            // Nome do agente
                            child: Text(
                              formatAgentName(room.agent?.name),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontSize: AppSizes.s02_5,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                        : const SizedBox(height: AppSizes.s03_5),

                    // Tempo da última mensagem
                    const SizedBox(height: AppSizes.s01),
                    Text(
                      formattedTime(),
                      style: TextStyle(color: colorScheme.onSurface, fontSize: AppSizes.s02_5),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
