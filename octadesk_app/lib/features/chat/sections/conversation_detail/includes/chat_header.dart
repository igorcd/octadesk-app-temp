import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/components/responsive/responsive_widgets.dart';
import 'package:octadesk_app/components/responsive/utils/screen_size.dart';
import 'package:octadesk_app/features/chat/providers/conversation_detail_provider.dart';
import 'package:octadesk_app/features/chat/providers/conversations_provider.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:provider/provider.dart';

class ChatHeader extends StatelessWidget {
  const ChatHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var chatProvider = Provider.of<ConversationsProvider>(context, listen: false);
    var screenWidth = MediaQuery.of(context).size.width;
    var isSm = screenWidth < ScreenSize.md;
    var isMd = screenWidth < ScreenSize.lg;
    var isXxl = screenWidth >= ScreenSize.xxl;

    return SizedBox(
      height: AppSizes.s18,
      child: Consumer<ConversationDetailProvider>(
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
                          if (isMd)
                            Padding(
                              padding: isSm ? EdgeInsets.zero : const EdgeInsets.only(left: AppSizes.s06),
                              child: OctaAvatar(
                                size: AppSizes.s11,
                                name: value.userName,
                                source: value.userAvatar,
                              ),
                            ),

                          // Nome do usuário
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: isSm ? AppSizes.s02 : AppSizes.s05),
                              child: OctaText.headlineMedium(
                                value.userName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
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
