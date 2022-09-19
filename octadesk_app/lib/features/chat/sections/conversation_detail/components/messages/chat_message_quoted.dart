import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_core/octadesk_core.dart';

class ChatMessageQuoted extends StatelessWidget {
  final MessageModel message;
  final double? maxWidth;
  final void Function() onTap;

  const ChatMessageQuoted({this.maxWidth, required this.message, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.s04, vertical: AppSizes.s02),
      decoration: BoxDecoration(
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
        color: Colors.white,
        border: Border.all(color: const Color.fromRGBO(0, 123, 255, .2), width: 1),
        borderRadius: const BorderRadius.all(
          Radius.circular(AppSizes.s03),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nome do usupario
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(AppIcons.reply, width: AppSizes.s05, color: AppColors.blue),
                  const SizedBox(width: AppSizes.s01),
                  Text(
                    message.user.name.length > 20 ? "${message.user.name.substring(0, 20)}..." : message.user.name,
                    style: TextStyle(color: AppColors.blue.shade400, fontWeight: FontWeight.bold, fontFamily: "Poppins"),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.s00_5),

              // Conteúdo da mensagem
              Text(
                message.comment.isNotEmpty ? message.comment : "📎 ${message.attachments.length} anexo${message.attachments.length > 1 ? 's' : ''}",
                style: TextStyle(fontFamily: "NotoSans", color: AppColors.info.shade800),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
