import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_core/models/message/message_attachment.dart';

class MediaDocumentContainer extends StatelessWidget {
  final MessageAttachment attachment;
  final bool isVertical;

  const MediaDocumentContainer({required this.isVertical, required this.attachment, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isVertical ? const EdgeInsets.all(AppSizes.s04) : const EdgeInsets.only(left: AppSizes.s02_5, right: AppSizes.s01),
      child: Flex(
        direction: isVertical ? Axis.vertical : Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: isVertical ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          // Tipo do arquivo
          Image.asset(AppIcons.file, width: AppSizes.s10),
          const SizedBox(
            width: AppSizes.s01_5,
            height: AppSizes.s00_5,
          ),
          // Conteúdo
          Flexible(
            flex: isVertical ? 0 : 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: isVertical ? CrossAxisAlignment.center : CrossAxisAlignment.start,
              children: [
                // Tipo
                Text(
                  attachment.extension.toUpperCase(),
                  style: const TextStyle(fontFamily: "Noto Sans", fontWeight: FontWeight.bold, color: AppColors.gray800, fontSize: AppSizes.s04_5),
                ),

                SizedBox(height: isVertical ? AppSizes.s01_5 : 0),
                // Título
                Text(
                  attachment.name,
                  maxLines: isVertical ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: isVertical ? TextAlign.center : TextAlign.left,
                  style: const TextStyle(
                    fontSize: AppSizes.s03,
                    fontFamily: "Noto Sans",
                    color: AppColors.gray800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
