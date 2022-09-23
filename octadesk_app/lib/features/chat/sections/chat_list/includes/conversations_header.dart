import 'package:flutter/material.dart';
import 'package:octadesk_app/features/chat/sections/chat_list/components/conversation_header_tab.dart';
import 'package:octadesk_app/resources/app_icons.dart';
import 'package:octadesk_app/resources/app_sizes.dart';

class ConversationsHeader extends StatelessWidget {
  final TabController controller;
  const ConversationsHeader({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: AppSizes.s18,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: AppSizes.s04, right: AppSizes.s01),

        // Conteúdo
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Row(
              children: [
                ConversationHeaderTab(
                  label: "Abertas",
                  selected: controller.index == 0,
                  onTap: () => controller.animateTo(0),
                ),
                ConversationHeaderTab(
                  label: "Encerradas",
                  selected: controller.index == 1,
                  onTap: () => controller.animateTo(1),
                ),
                const Spacer(),
                ConversationHeaderTab(
                  selected: controller.index == 2,
                  child: Image.asset(
                    AppIcons.add,
                    color: colorScheme.onSurface,
                    width: AppSizes.s06,
                  ),
                  onTap: () => controller.animateTo(2),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
