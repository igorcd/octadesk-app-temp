import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/components/responsive/responsive_container.dart';
import 'package:octadesk_app/components/responsive/utils/responsive.dart';
import 'package:octadesk_app/features/chat/sections/conversation_detail/includes/chat_footer.dart';
import 'package:octadesk_app/features/chat/sections/conversation_detail/includes/chat_body.dart';
import 'package:octadesk_app/features/chat/sections/conversation_detail/includes/chat_header.dart';
import 'package:octadesk_app/features/chat/sections/conversation_detail/includes/chat_informations.dart';
import 'package:octadesk_app/features/chat/sections/conversation_detail/includes/chat_macros_container.dart';
import 'package:octadesk_app/features/chat/sections/conversation_detail/includes/chat_mentions_container.dart';
import 'package:octadesk_app/features/chat/sections/conversation_detail/includes/chat_skeleton.dart';
import 'package:octadesk_app/features/chat/providers/conversation_detail_provider.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_core/models/room/room_model.dart';
import 'package:provider/provider.dart';

class ConversationDetail extends StatelessWidget {
  const ConversationDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var conversationDetailProvider = Provider.of<ConversationDetailProvider>(context);

    return StreamBuilder<RoomModel?>(
      stream: conversationDetailProvider.roomDetailStream,
      builder: (context, snapshot) {
        Widget content;

        // Erro
        if (snapshot.hasError) {
          content = OctaErrorContainer(subtitle: snapshot.error.toString());
        }

        // Caso esteja carregando
        else if (snapshot.data is! RoomModel || snapshot.connectionState == ConnectionState.done) {
          content = const ChatSkeleton();
        }

        // Caso tenha carregado
        else {
          content = Container(
            constraints: const BoxConstraints.expand(),
            child: Stack(
              children: [
                // Conteúdo do chat
                Positioned.fill(
                  child: ChatBody(
                    scrollController: conversationDetailProvider.scrollController,
                    room: snapshot.data!,
                  ),
                ),

                // Container de macros
                const ChatMacrosContainer(),

                // Container de menções
                const ChatMentionsContainer(),
              ],
            ),
          );
        }

        return ResponsiveContainer(
          decoration: Responsive(
            const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  color: Color.fromRGBO(0, 0, 0, .02),
                  offset: Offset(10, 0),
                ),
              ],
            ),
            xxl: const BoxDecoration(
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(AppSizes.s04),
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ChatHeader(),
              Divider(height: 2, thickness: 2, color: AppColors.info.shade100),
              const ChatInformations(),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  child: content,
                ),
              ),
              const ChatFooter(),
            ],
          ),
        );
      },
    );
  }
}
