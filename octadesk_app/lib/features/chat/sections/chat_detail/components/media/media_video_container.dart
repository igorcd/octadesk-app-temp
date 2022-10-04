import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/app_icons.dart';
import 'package:octadesk_app/resources/app_sizes.dart';
import 'package:octadesk_core/models/message/message_attachment.dart';

class MediaVideoContainer extends StatelessWidget {
  final MessageAttachment attachment;
  const MediaVideoContainer(this.attachment, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.s02),
        color: Colors.black87,
      ),
      child: Center(
        child: Image.asset(
          AppIcons.play,
          width: 48,
          color: Colors.white,
        ),
      ),
    );
  }
}
