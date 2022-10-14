import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:octadesk_app/features/chat/providers/chat_detail_provider.dart';
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
    var colorScheme = Theme.of(context).colorScheme;
    return Consumer<ChatDetailProvider>(
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
            minLines: 1,
            maxLines: 4,
            style: TextStyle(
              fontSize: AppSizes.s04,
              fontFamily: "NotoSans",
              fontWeight: FontWeight.normal,
              color: colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.s03, vertical: AppSizes.s04),
              border: InputBorder.none,
              hintText: "Digite a sua mensagem",
              hintStyle: TextStyle(
                fontFamily: "NotoSans",
                color: colorScheme.onBackground,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }
}
