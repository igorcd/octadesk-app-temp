import 'package:flutter/material.dart';
import 'package:octadesk_app/components/octa_icon_button.dart';
import 'package:octadesk_app/components/octa_tab_bar.dart';
import 'package:octadesk_app/components/octa_text.dart';
import 'package:octadesk_app/components/responsive/responsive_widgets.dart';
import 'package:octadesk_app/features/chat/providers/closed_conversations_provider.dart';
import 'package:octadesk_app/features/chat/sections/conversations_list/includes/closed_conversations.dart';
import 'package:octadesk_app/features/chat/sections/conversations_list/includes/opened_conversations.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:provider/provider.dart';

class ConversationsList extends StatefulWidget {
  final List<Widget> actions;
  const ConversationsList({required this.actions, Key? key}) : super(key: key);

  @override
  State<ConversationsList> createState() => _ConversationsListState();
}

class _ConversationsListState extends State<ConversationsList> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var isMobile = MediaQuery.of(context).size.width < ScreenSize.lg;

    return Container(
      color: Colors.white,
      child: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //
            // Header
            SizedBox(
              height: AppSizes.s18,
              child: Row(
                children: [
                  if (isMobile) ...[
                    OctaIconButton(
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      icon: AppIcons.menu,
                      iconSize: AppSizes.s06,
                    ),
                    Image.asset(AppImages.appLogoIcon, width: AppSizes.s09),
                  ],
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: isMobile ? AppSizes.s02 : AppSizes.s05),
                      child: OctaText.headlineMedium(
                        "Conversas",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  ...widget.actions,
                  const SizedBox(width: AppSizes.s02),
                ],
              ),
            ),
            const Divider(thickness: 2, height: 2, color: AppColors.gray100),

            // TabBar
            const OctaTabBar(
              tabs: ["Abertas", "Fechadas"],
            ),
            const Divider(thickness: 2, height: 2, color: AppColors.gray100),

            // Conteúdo
            Expanded(
              child: TabBarView(
                children: [
                  const OpenedConversations(),
                  ChangeNotifierProvider(
                    create: (context) => ClosedConversationsProvider(),
                    child: const ClosedConversations(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
