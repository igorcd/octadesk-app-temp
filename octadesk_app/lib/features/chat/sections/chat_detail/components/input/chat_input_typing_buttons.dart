import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/components/input/chat_input_submit_button.dart';
import 'package:octadesk_app/resources/index.dart';

class ChatInputTypingButtons extends StatelessWidget {
  final bool internalMessageActive;
  final void Function() onToogleInternalMessages;
  final void Function() onSubmit;

  const ChatInputTypingButtons({
    required this.internalMessageActive,
    required this.onToogleInternalMessages,
    required this.onSubmit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.s02, right: AppSizes.s02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OctaIconButton(
            onPressed: onToogleInternalMessages,
            icon: internalMessageActive ? AppIcons.eye : AppIcons.crossEye,
            color: internalMessageActive ? colorScheme.tertiary : colorScheme.onSecondary,
            size: AppSizes.s08,
            iconSize: AppSizes.s06,
          ),
          const SizedBox(width: AppSizes.s01_5),
          ChatInputSubmitButton(
            internalMessageActive: internalMessageActive,
            onTap: onSubmit,
          ),
        ],
      ),
    );
  }
}
