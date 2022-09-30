import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/app_sizes.dart';

class ChatClosingDetails extends StatelessWidget {
  final String userName;
  const ChatClosingDetails({required this.userName, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.only(top: AppSizes.s05, bottom: bottomPadding > 0 ? bottomPadding : AppSizes.s05),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'Conversa encerrada por ',
          style: Theme.of(context).textTheme.bodyText2,
          children: [
            TextSpan(text: userName, style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
