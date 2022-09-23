import 'dart:io';

import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_core/models/message/message_attachment.dart';

class MediaPictureContainer extends StatelessWidget {
  final MessageAttachment attachment;
  final bool stretchImage;

  const MediaPictureContainer({required this.attachment, required this.stretchImage, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return attachment.localFilePath != null
        ? Image.file(
            File(attachment.localFilePath!),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          )
        : FadeInImage.assetNetwork(
            alignment: Alignment.center,
            imageErrorBuilder: (context, error, stackTrace) {
              return Image.asset(
                AppIcons.pictureError,
                width: stretchImage ? double.infinity : null,
                height: stretchImage ? double.infinity : null,
              );
            },
            fadeInDuration: const Duration(milliseconds: 300),
            fadeOutDuration: const Duration(milliseconds: 300),
            placeholder: AppIcons.picture,
            image: attachment.url,
            fit: BoxFit.cover,
            width: stretchImage ? double.infinity : null,
            height: stretchImage ? double.infinity : null,
          );
  }
}
