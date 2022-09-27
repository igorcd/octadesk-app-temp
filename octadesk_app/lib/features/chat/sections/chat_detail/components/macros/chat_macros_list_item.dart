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

      // Botão
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
                // Título
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "NotoSans",
                    fontSize: AppSizes.s03,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),

                // Conteúdo
                if (content != null && content!.isNotEmpty)
                  Text(
                    content!,
                    style: const TextStyle(
                      fontFamily: "NotoSans",
                      fontSize: AppSizes.s03,
                    ),
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
