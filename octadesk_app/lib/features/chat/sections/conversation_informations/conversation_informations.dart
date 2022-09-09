import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/components/responsive/utils/screen_size.dart';
import 'package:octadesk_app/features/chat/sections/conversation_informations/components/conversation_history_button.dart';
import 'package:octadesk_app/features/chat/sections/conversation_informations/includes/conversation_events.dart';
import 'package:octadesk_app/features/chat/providers/conversation_detail_provider.dart';
import 'package:octadesk_app/resources/app_icons.dart';
import 'package:octadesk_app/resources/app_sizes.dart';
import 'package:octadesk_core/models/index.dart';
import 'package:provider/provider.dart';

class ConversationInformations extends StatelessWidget {
  const ConversationInformations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isXxl = MediaQuery.of(context).size.width >= ScreenSize.xxl;
    var conversationDetailProvider = Provider.of<ConversationDetailProvider>(context);

    return StreamBuilder<RoomModel?>(
      stream: conversationDetailProvider.roomDetailStream,
      builder: (context, snapshot) {
        // Conteúdo
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //
            // Container superior
            Container(
              constraints: isXxl ? const BoxConstraints(minHeight: 200) : null,
              padding: const EdgeInsets.all(AppSizes.s04),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(AppSizes.s04),
                ),
              ),

              // Informações do usuário
              child: Column(
                crossAxisAlignment: isXxl ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                children: [
                  //
                  // Avatar do usuário
                  OctaAvatar(
                    size: isXxl ? AppSizes.s25 : AppSizes.s30,
                    fontSize: isXxl ? AppSizes.s06 : AppSizes.s08,
                    name: conversationDetailProvider.userName,
                    source: conversationDetailProvider.userAvatar,
                  ),
                  const SizedBox(height: AppSizes.s02),

                  // Nome do usuário
                  OctaText.headlineMedium(conversationDetailProvider.userName),

                  // E-mail do usuário
                  OctaText.bodySmall(
                    snapshot.data?.createdBy.email ?? "Carregando",
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            if (isXxl) const SizedBox(height: AppSizes.s03) else const Divider(height: 1, thickness: 1),

            // Informações da conversa
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isXxl ? Colors.white : Colors.transparent,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(AppSizes.s04),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: AppSizes.s04),
                  //
                  // Informações da conversa
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSizes.s04),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            OctaText.displaySmall("Sobre a conversa"),
                            const SizedBox(height: AppSizes.s01),

                            // Id Da conversa
                            OctaText.bodySmall("ID: ${snapshot.data?.number ?? 'Carregando'}"),
                            const SizedBox(height: AppSizes.s06),

                            // Tags
                            OctaText.bodyLarge("Tags"),
                            const SizedBox(height: AppSizes.s02),

                            // Carregando
                            if (snapshot.data == null)
                              OctaText.bodySmall("Carregando")

                            // Lista de tags
                            else
                              Wrap(
                                direction: Axis.horizontal,
                                spacing: AppSizes.s01_5,
                                runSpacing: AppSizes.s01_5,
                                children: [
                                  ...snapshot.data!.tags
                                      .map(
                                        (e) => OctaTag(
                                          onPressed: () => conversationDetailProvider.deleteTag(e.id, context),
                                          placeholder: e.name,
                                          active: true,
                                        ),
                                      )
                                      .toList(),
                                  OctaTag(
                                    onPressed: () => conversationDetailProvider.manageTags(context),
                                    placeholder: "Gerênciar",
                                    icon: AppIcons.add,
                                  ),
                                ],
                              ),
                            const SizedBox(height: AppSizes.s06),

                            if (snapshot.data?.createdBy.id.isNotEmpty == true) ...[
                              // Histórico de conversas
                              OctaText.bodyLarge("Histórico de conversas"),
                              const SizedBox(height: AppSizes.s02),
                              FutureBuilder<List<RoomModel>>(
                                future: conversationDetailProvider.lastConversationsFuture,
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                                    return OctaText.bodySmall("Carregando");
                                  }

                                  if (snapshot.hasError) {
                                    return OctaText.bodySmall("Não foi possível carregar as últimas conversas, tente novamente em breve");
                                  }

                                  return ListView.separated(
                                    itemCount: snapshot.data!.length,
                                    shrinkWrap: true,
                                    separatorBuilder: (context, index) => const SizedBox(height: AppSizes.s01),
                                    itemBuilder: (context, index) {
                                      return ConversationHistoryButton(
                                        date: snapshot.data![index].lastMessageDate,
                                        onTap: () => conversationDetailProvider.openHistoryConversation(context, snapshot.data![index]),
                                      );
                                    },
                                  );
                                },
                              ),
                              const SizedBox(height: AppSizes.s03),
                            ]
                          ],
                        ),
                      ),

                      // Eventos da conversa
                      OctaExpansionPanel(
                        isOpened: false,
                        title: "Eventos da conversa",
                        content: ConversationEvents(
                          loading: snapshot.data == null,
                          events: snapshot.data?.events ?? [],
                        ),
                      ),
                      const SizedBox(height: AppSizes.s02),

                      // Tickets
                      // OctaExpansionPanel(
                      //   isOpened: false,
                      //   title: "Tickets",
                      //   content: Column(children: [
                      //     OctaText.bodySmall("Essa conversa não possui tickets"),
                      //   ]),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
