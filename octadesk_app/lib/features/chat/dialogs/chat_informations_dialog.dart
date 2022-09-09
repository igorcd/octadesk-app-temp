import 'package:flutter/material.dart';
import 'package:octadesk_app/features/chat/providers/conversation_detail_provider.dart';
import 'package:octadesk_app/features/chat/sections/conversation_informations/conversation_informations.dart';
import 'package:provider/provider.dart';

class ChatInformationsDialog extends StatelessWidget {
  final ConversationDetailProvider conversationDetails;
  const ChatInformationsDialog(this.conversationDetails, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: conversationDetails,
      child: Consumer<ConversationDetailProvider>(
        builder: (context, value, child) {
          return const ConversationInformations();
        },
      ),
    );
  }
}
