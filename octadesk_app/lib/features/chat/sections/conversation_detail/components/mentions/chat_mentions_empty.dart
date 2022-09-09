import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';

class ChatMentionsEmpty extends StatelessWidget {
  final String message;
  const ChatMentionsEmpty(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: AppSizes.s15,
      child: Text(
        message,
        style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: "NotoSans", fontSize: AppSizes.s03, color: AppColors.gray800),
      ),
    );
  }
}
