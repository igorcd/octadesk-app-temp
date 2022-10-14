import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/components/responsive/responsive_widgets.dart';
import 'package:octadesk_app/components/responsive/utils/screen_size.dart';
import 'package:octadesk_app/features/chat/providers/chat_detail_provider.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/components/header/chat_options.dart';
import 'package:octadesk_app/features/chat/store/chat_store.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_core/models/index.dart';
import 'package:provider/provider.dart';

class ChatHeader extends StatelessWidget {
  const ChatHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var chatProvider = Provider.of<ChatStore>(context, listen: false);
    var screenWidth = MediaQuery.of(context).size.width;
    var isSm = screenWidth < ScreenSize.md;
    var isXxl = screenWidth >= ScreenSize.xxl;
    var formatter = DateFormat("dd/MM/yyyy 'às' HH:mm", "pt_BR");

    ChatDetailProvider chatDetailProvider = Provider.of(context);

    return Container(
      height: AppSizes.s18,
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.outline, width: 1))),
      child: StreamBuilder<RoomModel?>(
        stream: chatDetailProvider.roomDetailStream,
        builder: (context, snapshot) {
          var roomIsOpened = snapshot.data?.closingDetails?.closedBy == null;

          return Row(
            children: [
              // Botão de voltar
              if (isSm)
                OctaIconButton(
                  onPressed: () => chatProvider.closeConversation(),
                  icon: AppIcons.arrowBack,
                  iconSize: AppSizes.s06,
                ),

              // Botão do usuário
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: isXxl ? null : () => chatDetailProvider.showConversationInformations(context),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.s01),
                      child: Row(
                        children: [
                          //
                          // Avatar do usuário
                          Padding(
                            padding: isSm ? const EdgeInsets.only(right: AppSizes.s04) : const EdgeInsets.only(left: AppSizes.s04, right: AppSizes.s04),
                            child: OctaAvatar(
                              size: AppSizes.s12,
                              name: chatDetailProvider.userName,
                              source: chatDetailProvider.userAvatar,
                            ),
                          ),

                          // Nome do usuário
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                OctaText.titleLarge(chatProvider.currentConversation?.userName ?? ""),
                                OctaText.labelMedium(
                                  snapshot.data != null ? "Chat iniciado em ${formatter.format(snapshot.data!.createdAt.toLocal())}" : "Carregando...",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Transferir
              if (roomIsOpened && !isSm) ...[
                OctaIconButton(
                  onPressed: () => chatDetailProvider.transferChat(context),
                  icon: AppIcons.transfer,
                  size: AppSizes.s08,
                  iconSize: AppSizes.s05,
                ),
                const SizedBox(width: AppSizes.s02),

                // Finalizar
                OctaIconButton(
                  onPressed: () => chatDetailProvider.openFinishConversationDialog(context),
                  icon: AppIcons.check,
                  size: AppSizes.s08,
                  iconSize: AppSizes.s05,
                ),
                const SizedBox(width: AppSizes.s04),
              ],
              if (roomIsOpened && isSm)
                ChatOptions(
                  options: [
                    ChatOptionItem(text: "Transferir", action: () => chatDetailProvider.transferChat(context)),
                    ChatOptionItem(text: "Finalizar", action: () => chatDetailProvider.openFinishConversationDialog(context)),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}
