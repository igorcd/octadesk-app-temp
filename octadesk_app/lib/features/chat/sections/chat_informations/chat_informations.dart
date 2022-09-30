import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/features/chat/providers/chat_detail_provider.dart';
import 'package:octadesk_app/features/chat/sections/chat_informations/includes/chat_events.dart';
import 'package:octadesk_app/features/chat/sections/chat_informations/includes/chat_history.dart';
import 'package:octadesk_app/resources/app_icons.dart';
import 'package:octadesk_app/resources/app_sizes.dart';
import 'package:octadesk_app/utils/helper_functions.dart';
import 'package:octadesk_core/models/index.dart';
import 'package:provider/provider.dart';

class ChatInformations extends StatelessWidget {
  const ChatInformations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var conversationDetailProvider = Provider.of<ChatDetailProvider>(context);

    return StreamBuilder<RoomModel?>(
      stream: conversationDetailProvider.roomDetailStream,
      builder: (context, snapshot) {
        return ListView(
          children: [
            ListView(
              padding: const EdgeInsets.only(right: AppSizes.s04, left: AppSizes.s04, top: AppSizes.s04),
              shrinkWrap: true,
              children: [
                // Avatar do usuário
                Center(
                  child: OctaAvatar(
                    size: AppSizes.s30,
                    fontSize: AppSizes.s06,
                    name: conversationDetailProvider.userName,
                    source: conversationDetailProvider.userAvatar,
                  ),
                ),

                // Nome do usuário
                const SizedBox(height: AppSizes.s06),
                OctaText.displaySmall(conversationDetailProvider.userName, textAlign: TextAlign.center),

                // Email do usuário
                const SizedBox(height: AppSizes.s01),
                OctaText.bodySmall(
                  snapshot.data?.createdBy.email ?? "Carregando",
                  textAlign: TextAlign.center,
                ),

                // Telefone
                const SizedBox(height: AppSizes.s01),
                OctaText.bodySmall(
                  snapshot.data?.integrator?.to != null ? setPhoneMaskHelper(snapshot.data!.integrator!.to) : " ",
                  textAlign: TextAlign.center,
                ),

                // Id Da conversa
                const SizedBox(height: AppSizes.s01),
                OctaText.labelMedium(
                  "ID: ${snapshot.data?.number ?? 'Carregando'}",
                  textAlign: TextAlign.center,
                ),

                // Tags
                const SizedBox(height: AppSizes.s06),
                OctaText.bodyLarge("Tags"),
                const SizedBox(height: AppSizes.s02),

                Row(
                  children: [
                    OctaTag(
                      onPressed: () => conversationDetailProvider.manageTags(context),
                      placeholder: "adicionar",
                      icon: AppIcons.add,
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.s02),

                // Carregando
                if (snapshot.data == null)
                  OctaText.bodySmall("Carregando")

                // Lista de tags
                else ...[
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
                    ],
                  ),
                  const SizedBox(height: AppSizes.s06),
                ],
              ],
            ),
            const Divider(indent: AppSizes.s04, endIndent: AppSizes.s04),

            //Histórico de Conversas
            if (snapshot.data?.createdBy.id.isNotEmpty == true) ...[
              OctaExpansionPanel(
                isOpened: false,
                title: "Histórico",
                content: ChatHistory(
                  onOpenConversation: (room) => conversationDetailProvider.openHistoryConversation(context, room),
                ),
              ),
              const Divider(indent: AppSizes.s04, endIndent: AppSizes.s04),
            ],

            // Eventos
            OctaExpansionPanel(
              isOpened: false,
              title: "Eventos",
              content: ChatEvents(
                loading: snapshot.data == null,
                events: snapshot.data?.events ?? [],
              ),
            ),
          ],
        );

        // //
        // // Conteúdo
        // return Column(
        //   crossAxisAlignment: CrossAxisAlignment.stretch,
        //   children: [
        //     //
        //     // Container superior
        //     Container(
        //       constraints: isXxl ? const BoxConstraints(minHeight: 200) : null,
        //       padding: const EdgeInsets.all(AppSizes.s04),
        //       decoration: const BoxDecoration(
        //         color: Colors.white,
        //         borderRadius: BorderRadius.horizontal(
        //           left: Radius.circular(AppSizes.s04),
        //         ),
        //       ),

        //       // Informações do usuário
        //       child: Column(
        //         crossAxisAlignment: isXxl ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        //         children: [
        //           //
        //           // Avatar do usuário
        //           OctaAvatar(
        //             size: isXxl ? AppSizes.s25 : AppSizes.s30,
        //             fontSize: isXxl ? AppSizes.s06 : AppSizes.s08,
        //             name: conversationDetailProvider.userName,
        //             source: conversationDetailProvider.userAvatar,
        //           ),
        //           const SizedBox(height: AppSizes.s02),

        //           // Nome do usuário
        //           OctaText.headlineMedium(conversationDetailProvider.userName),

        //           // E-mail do usuário
        //           OctaText.bodySmall(
        //             snapshot.data?.createdBy.email ?? "Carregando",
        //             maxLines: 1,
        //           ),
        //         ],
        //       ),
        //     ),
        //     if (isXxl) const SizedBox(height: AppSizes.s03) else const Divider(height: 1, thickness: 1),

        //     // Informações da conversa
        //     Expanded(
        //       child: Container(
        //         decoration: BoxDecoration(
        //           color: isXxl ? Colors.white : Colors.transparent,
        //           borderRadius: const BorderRadius.horizontal(
        //             left: Radius.circular(AppSizes.s04),
        //           ),
        //         ),
        //         child: SingleChildScrollView(
        //           padding: const EdgeInsets.symmetric(vertical: AppSizes.s04),
        //           //
        //           // Informações da conversa
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.stretch,
        //             children: [
        //               Padding(
        //                 padding: const EdgeInsets.symmetric(horizontal: AppSizes.s04),
        //                 child: Column(
        //                   crossAxisAlignment: CrossAxisAlignment.stretch,
        //                   children: [
        //                     OctaText.displaySmall("Sobre a conversa"),
        //                     const SizedBox(height: AppSizes.s01),

        //                     const SizedBox(height: AppSizes.s06),

        //                     if (snapshot.data?.createdBy.id.isNotEmpty == true) ...[
        //                       // Histórico de conversas
        //
        //                     ]
        //                   ],
        //                 ),
        //               ),

        //               // Eventos da conversa
        //               OctaExpansionPanel(
        //                 isOpened: false,
        //                 title: "Eventos da conversa",
        //                 content: ChatEvents(
        //                   loading: snapshot.data == null,
        //                   events: snapshot.data?.events ?? [],
        //                 ),
        //               ),
        //               const SizedBox(height: AppSizes.s02),

        //               // Tickets
        //               // OctaExpansionPanel(
        //               //   isOpened: false,
        //               //   title: "Tickets",
        //               //   content: Column(children: [
        //               //     OctaText.bodySmall("Essa conversa não possui tickets"),
        //               //   ]),
        //               // ),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // );
      },
    );
  }
}
