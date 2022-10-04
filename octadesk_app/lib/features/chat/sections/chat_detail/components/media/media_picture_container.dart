import 'dart:io';

import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_core/models/message/message_attachment.dart';

class MediaPictureContainer extends StatelessWidget {
  final MessageAttachment attachment;

  const MediaPictureContainer({required this.attachment, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppSizes.s02)),
      child: attachment.localFilePath != null
          ? Image.file(
              File(attachment.localFilePath!),
              fit: BoxFit.cover,
              alignment: Alignment.center,
            )
          : Image.network(
              attachment.url,
              alignment: Alignment.center,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Image.asset(
                    AppIcons.pictureError,
                    width: 48,
                    color: colorScheme.error,
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                return loadingProgress == null
                    ? child
                    : Center(
                        child: OctaPulseAnimation(
                          child: Image.asset(
                            AppIcons.picture,
                            width: 48,
                            color: colorScheme.onBackground,
                          ),
                        ),
                      );
              },
              fit: BoxFit.cover,
            ),
    );
  }
}
