import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:octadesk_app/features/chat/sections/conversation_detail/components/header/chat_information_item.dart';
import 'package:octadesk_app/features/chat/providers/conversation_detail_provider.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_app/utils/helper_functions.dart';
import 'package:octadesk_core/models/index.dart';
import 'package:provider/provider.dart';

class ChatInformations extends StatefulWidget {
  const ChatInformations({Key? key}) : super(key: key);

  @override
  State<ChatInformations> createState() => _ChatInformationsState();
}

class _ChatInformationsState extends State<ChatInformations> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.ease);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var conversationDetailProvider = Provider.of<ConversationDetailProvider>(context);

    var formatter = DateFormat("dd/MM/yyyy 'às' HH:mm", "pt_BR");

    return Container(
        // Estilização
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: AppColors.info.shade100, width: 2)),
        ),

        // Conteúdo
        child: StreamBuilder<RoomModel?>(
          stream: conversationDetailProvider.roomDetailStream,
          builder: (context, snapshot) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //
                // Botão
                SizedBox(
                  height: AppSizes.s12,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _controller.isCompleted ? _controller.reverse() : _controller.forward(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //
                          // Data que a conversa foi iniciada
                          Text(
                            snapshot.data != null ? "Chat iniciado em ${formatter.format(snapshot.data!.createdAt.toLocal())}" : "Carregando...",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: AppColors.info.shade800,
                            ),
                          ),
                          const SizedBox(height: AppSizes.s02),

                          // Seta
                          RotationTransition(
                            turns: Tween<double>(begin: 0, end: .5).animate(_animation),
                            child: Image.asset(AppIcons.angleDown, width: AppSizes.s05),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Informações
                if (snapshot.data != null)
                  SizeTransition(
                    sizeFactor: _animation,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: AppSizes.s02, bottom: AppSizes.s04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (snapshot.data!.agent != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: AppSizes.s03),
                              child: ChatInformationItem(title: "Conversa atribuída a: ", value: snapshot.data!.agent!.name),
                            ),
                          if (snapshot.data!.group != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: AppSizes.s03),
                              child: ChatInformationItem(title: "Grupo: ", value: snapshot.data!.group!.name),
                            ),
                          if (snapshot.data!.createdBy.phones.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: AppSizes.s03),
                              child: ChatInformationItem(
                                  title: "Origem da conversa: ",
                                  value: setPhoneMaskHelper("${snapshot.data!.createdBy.phones[0].countryCode}${snapshot.data!.createdBy.phones[0].number}")),
                            ),
                          ChatInformationItem(title: "Identificador da conversa: ", value: snapshot.data!.number),
                        ],
                      ),
                    ),
                  )
              ],
            );
          },
        ));
  }
}
