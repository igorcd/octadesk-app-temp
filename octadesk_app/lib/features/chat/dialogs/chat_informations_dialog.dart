import 'package:flutter/material.dart';
import 'package:octadesk_app/features/chat/providers/chat_detail_provider.dart';
import 'package:octadesk_app/features/chat/sections/chat_informations/chat_informations.dart';
import 'package:provider/provider.dart';

class ChatInformationsDialog extends StatelessWidget {
  final ChatDetailProvider conversationDetails;
  const ChatInformationsDialog(this.conversationDetails, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: conversationDetails,
      child: Consumer<ChatDetailProvider>(
        builder: (context, value, child) {
          return const ChatInformations();
        },
      ),
    );
  }
}
