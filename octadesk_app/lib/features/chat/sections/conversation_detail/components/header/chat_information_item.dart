import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';

class ChatInformationItem extends StatelessWidget {
  final String title;
  final String value;
  const ChatInformationItem({required this.title, required this.value, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: title,
        style: const TextStyle(fontFamily: "NotoSans", color: AppColors.gray800, fontSize: AppSizes.s03),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(fontFamily: "NotoSans", fontWeight: FontWeight.bold, color: AppColors.gray800, fontSize: AppSizes.s03),
          )
        ],
      ),
    );
  }
}
