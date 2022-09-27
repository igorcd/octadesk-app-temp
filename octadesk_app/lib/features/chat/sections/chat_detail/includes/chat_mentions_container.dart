import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/components/mentions/chat_mentions_empty.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/components/mentions/chat_mentions_list_item.dart';
import 'package:octadesk_app/features/chat/providers/chat_detail_provider.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_conversation/octadesk_conversation.dart';
import 'package:octadesk_core/octadesk_core.dart';
import 'package:provider/provider.dart';

class ChatMentionsContainer extends StatelessWidget {
  const ChatMentionsContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: AppSizes.s04,
      left: AppSizes.s06,
      right: AppSizes.s06,
      child: Consumer<ChatDetailProvider>(
        builder: (context, value, child) {
          List<AgentDTO> filteredAgents = value.mentionFilter.isNotEmpty
              ? OctadeskConversation.instance.agents.where((e) {
                  return e.name.toLowerCase().contains(value.mentionFilter.replaceAll('@', '').toLowerCase());
                }).toList()
              : OctadeskConversation.instance.agents;

          Widget child() {
            if (filteredAgents.isEmpty) {
              return const ChatMentionsEmpty("Não foram encontrados agentes");
            }

            return ListView.separated(
              controller: ScrollController(),
              itemCount: filteredAgents.length,
              reverse: true,
              separatorBuilder: (context, index) => const Divider(thickness: 2, height: 2),
              itemBuilder: (context, index) {
                var agent = filteredAgents[index];
                return ChatMentionsListItem(agent, onPressed: () => value.selectAgentInMentionsCallback!(agent.name));
              },
            );
          }

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: value.selectAgentInMentionsCallback != null
                ? PhysicalModel(
                    color: Colors.transparent,
                    borderRadius: const BorderRadius.all(Radius.circular(AppSizes.s03)),
                    elevation: 8,
                    shadowColor: const Color.fromRGBO(0, 0, 0, .55),

                    // Clip do efeito de backdrop
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(AppSizes.s03),
                      ),
                      child: BackdropFilter(
                        //
                        // Efeito Blur
                        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),

                        // Container principal
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          // Altura do conainer
                          height: (AppSizes.s15 + 2) * math.min(math.max(filteredAgents.length, 1), 3),

                          // Estilização
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.info.shade100),
                            borderRadius: const BorderRadius.all(Radius.circular(AppSizes.s03)),
                            color: const Color.fromRGBO(255, 255, 255, .9),
                          ),
                          //
                          // Lista de macros
                          child: child(),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
