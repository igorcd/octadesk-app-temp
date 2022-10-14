import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/app_sizes.dart';

class ChatOptionItem {
  final String text;
  final void Function() action;

  ChatOptionItem({required this.text, required this.action});
}

class ChatOptions extends StatelessWidget {
  final List<ChatOptionItem> options;
  const ChatOptions({required this.options, super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.s04),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.s04)),
      itemBuilder: (context) {
        return options
            .map(
              (e) => PopupMenuItem(
                onTap: e.action,
                child: Text(e.text),
              ),
            )
            .toList();
      },
    );
  }
}
