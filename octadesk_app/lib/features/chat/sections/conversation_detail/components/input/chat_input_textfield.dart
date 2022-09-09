import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:octadesk_app/features/chat/providers/conversation_detail_provider.dart';
import 'package:octadesk_app/resources/app_colors.dart';
import 'package:octadesk_app/resources/app_sizes.dart';
import 'package:provider/provider.dart';
import 'package:rich_text_controller/rich_text_controller.dart';

class ChatInputTextField extends StatelessWidget {
  final RichTextController controller;
  final FocusNode focusNode;
  final void Function() onSubmit;
  const ChatInputTextField({required this.focusNode, required this.controller, required this.onSubmit, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isMobile = MediaQuery.of(context).size.width < 640;

    return Consumer<ConversationDetailProvider>(
      builder: (context, value, child) {
        return Focus(
          onFocusChange: (inFocus) => value.inputInFocus = inFocus,
          onKey: (node, event) {
            if (!event.isShiftPressed && event.logicalKey == LogicalKeyboardKey.enter) {
              onSubmit();
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: TextField(
            focusNode: focusNode,
            controller: controller,
            textInputAction: TextInputAction.none,
            minLines: isMobile ? 1 : 2,
            maxLines: 4,
            style: const TextStyle(
              fontSize: AppSizes.s04,
              fontFamily: "NotoSans",
              fontWeight: FontWeight.normal,
              color: AppColors.gray800,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.s04, vertical: AppSizes.s04),
              border: InputBorder.none,
              hintText: isMobile ? "Digite a sua mensagem" : "Digite / para adicionar uma mensagem pronta",
              hintStyle: const TextStyle(
                fontFamily: "NotoSans",
                color: AppColors.gray400,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }
}
