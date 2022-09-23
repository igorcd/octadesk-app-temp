import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/app_sizes.dart';

class ChatInputTab extends StatelessWidget {
  final String text;
  final bool selected;
  final void Function() onTap;
  const ChatInputTab({required this.onTap, required this.text, required this.selected, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: selected ? 1 : .4,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.s02),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: selected ? Theme.of(context).colorScheme.primary : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: AppSizes.s03_5),
            ),
          ),
        ),
      ),
    );
  }
}
