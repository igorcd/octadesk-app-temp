import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/app_sizes.dart';
import 'package:octadesk_core/models/message/message_attachment.dart';

class MediaNotSupportedContainer extends StatelessWidget {
  final MessageAttachment attachment;
  const MediaNotSupportedContainer({required this.attachment, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppSizes.s02),
      child: Text(
        "Mídia não suportada",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
