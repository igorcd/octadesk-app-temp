import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/app_colors.dart';
import 'package:octadesk_app/utils/helper_functions.dart';
import 'package:styled_text/styled_text.dart';

class ChatMessageContent extends StatelessWidget {
  final String content;
  final bool isInternal;

  const ChatMessageContent(this.content, {this.isInternal = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var hyperlinkRegex = RegExp(
        r"(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})");

    var text = content.replaceAllMapped(hyperlinkRegex, (match) => "<a>${match[0]}</a>");

    // Tratar menções
    if (isInternal) {
      text = text.split(' ').map((e) {
        if (e.startsWith("@")) {
          return '<quoted>$e</quoted>';
        }
        return e;
      }).join(' ');
    }

    return StyledText(
      style: const TextStyle(fontFamily: "NotoSans"),
      text: text,
      tags: {
        'p': StyledTextTag(style: const TextStyle(fontWeight: FontWeight.normal)),
        'a': StyledTextActionTag(
          (text, attributes) {
            if (text != null) {
              openExternalLink(context, text);
            }
          },
          style: TextStyle(color: AppColors.blue),
        ),
        'quoted': StyledTextTag(
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.warning.shade800,
          ),
        ),
        'b': StyledTextTag(style: const TextStyle(fontWeight: FontWeight.bold)),
        'i': StyledTextTag(style: const TextStyle(fontStyle: FontStyle.italic)),
        'u': StyledTextTag(style: const TextStyle(decoration: TextDecoration.underline)),
        'header': StyledTextTag(style: const TextStyle(fontWeight: FontWeight.bold)),
        'body': StyledTextTag(style: const TextStyle(fontWeight: FontWeight.normal)),
        'footer': StyledTextTag(style: const TextStyle(fontStyle: FontStyle.italic)),
      },
    );
  }
}
