import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';

class ChatMacrosListItem extends StatelessWidget {
  final String title;
  final String? content;
  final void Function()? onPressed;
  const ChatMacrosListItem({required this.title, this.content, this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.s15,
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.s04),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "NotoSans", fontSize: AppSizes.s03, color: AppColors.info.shade800),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                if (content != null && content!.isNotEmpty)
                  Text(
                    content!,
                    style: TextStyle(fontFamily: "NotoSans", fontSize: AppSizes.s03, color: AppColors.info),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
