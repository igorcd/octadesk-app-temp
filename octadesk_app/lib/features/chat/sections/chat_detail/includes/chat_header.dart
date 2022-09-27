import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/components/responsive/responsive_widgets.dart';
import 'package:octadesk_app/components/responsive/utils/screen_size.dart';
import 'package:octadesk_app/features/chat/providers/chat_detail_provider.dart';
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

    return Container(
      height: AppSizes.s18,
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.outline, width: 1))),
      child: Consumer<ChatDetailProvider>(
        builder: (context, value, child) {
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
                    onTap: isXxl ? null : () => value.showConversationInformations(context),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.s01),
                      child: Row(
                        children: [
                          //
                          // Avatar do usuário
                          Padding(
                            padding: isSm ? EdgeInsets.zero : const EdgeInsets.only(left: AppSizes.s04, right: AppSizes.s04),
                            child: OctaAvatar(
                              size: AppSizes.s12,
                              name: value.userName,
                              source: value.userAvatar,
                            ),
                          ),

                          // Nome do usuário
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                OctaText.titleLarge(chatProvider.currentConversation!.userName),
                                StreamBuilder<RoomModel?>(
                                  stream: chatProvider.currentConversation!.roomDetailStream,
                                  builder: (context, snapshot) {
                                    return OctaText.labelMedium(
                                      snapshot.data != null ? "Chat iniciado em ${formatter.format(snapshot.data!.createdAt.toLocal())}" : "Carregando...",
                                    );
                                  },
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

              OctaIconButton(
                onPressed: () {},
                icon: AppIcons.transfer,
                size: AppSizes.s08,
                iconSize: AppSizes.s05,
              ),
              const SizedBox(width: AppSizes.s02),
              OctaIconButton(
                onPressed: () {},
                icon: AppIcons.check,
                size: AppSizes.s08,
                iconSize: AppSizes.s05,
              ),
              const SizedBox(width: AppSizes.s04),
            ],
          );
        },
      ),
    );
  }
}
