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
      padding: const EdgeInsets.all(AppSizes.s02),
      color: selected ? AppColors.gray100 : Colors.transparent,
      height: AppSizes.s20,
      child: Material(
        borderRadius: BorderRadius.circular(AppSizes.s03_5),
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,

        // Botão
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.s01_5),
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
                const SizedBox(width: AppSizes.s03),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //
                      // Nome do usuário
                      OctaText.titleMedium(
                        room.user.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.s02, top: AppSizes.s02),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      room.agent != null
                          ? Container(
                              constraints: const BoxConstraints(maxWidth: 80),
                              height: AppSizes.s03_5,
                              padding: const EdgeInsets.symmetric(horizontal: AppSizes.s01),
                              decoration: BoxDecoration(color: AppColors.gray200, borderRadius: BorderRadius.circular(AppSizes.s10)),

                              // Nome do agente
                              child: Text(
                                formatAgentName(room.agent?.name),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.gray600,
                                  fontSize: AppSizes.s02_5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                          : const SizedBox(height: AppSizes.s03_5),

                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: room.hasNewMessage ? const OctaNotificationIndicator() : const SizedBox.shrink(),
                      ),

                      // Tempo da última mensagem
                      Text(
                        formattedTime(),
                        style: const TextStyle(color: AppColors.gray600, fontSize: AppSizes.s02_5),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
