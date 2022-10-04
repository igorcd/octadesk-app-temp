import 'package:flutter/material.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/components/media/media_audio_container.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/components/media/media_container.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/components/media/media_document_container.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/components/media/media_more_attachments._container.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/components/media/media_not_supported_container.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/components/media/media_picture_container.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/components/media/media_video_container.dart';
import 'package:octadesk_app/resources/app_sizes.dart';
import 'package:octadesk_core/models/message/message_attachment.dart';
import 'package:octadesk_core/octadesk_core.dart';
import 'dart:math' as math;

class MultipleMediaContainer extends StatelessWidget {
  final List<MessageAttachment> attachments;
  const MultipleMediaContainer(this.attachments, {super.key});

  @override
  Widget build(BuildContext context) {
    // Container
    Widget attachmentContainer(int index) {
      Widget child;

      var attachment = attachments[index];

      // Mais de 4 anexos
      if (index == 3 && attachments.length > 4) {
        child = const MediaMoreAttachmentsContainer();
      }

      // Não suportado
      else if (attachment.isUnsupported) {
        child = MediaNotSupportedContainer(attachment: attachment);
      }
      // Foto
      else if (attachment.type == AttachmentTypeEnum.photo) {
        child = MediaContainer(
          child: MediaPictureContainer(attachment: attachment),
        );
      }

      // Audio
      else if (attachment.type == AttachmentTypeEnum.audio) {
        child = MediaContainer(
          child: MediaAudioContainer(
            attachment: attachment,
            isVertical: true,
          ),
        );
      }

      // Video
      else if (attachment.type == AttachmentTypeEnum.video) {
        child = MediaContainer(
          child: MediaVideoContainer(attachment),
        );
      }

      // Documento
      else {
        child = MediaContainer(
          child: MediaDocumentContainer(
            attachment: attachment,
            isVertical: true,
          ),
        );
      }

      return Container(
        width: attachments.length == 3 && index == 2 ? null : 144,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppSizes.s02),
        ),
        child: AspectRatio(
          aspectRatio: attachments.length == 3 && index == 2 ? 2 : 1,
          child: child,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(AppSizes.s01),
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 4,
        runSpacing: 4,
        children: List.generate(
          math.min(attachments.length, 4),
          (index) {
            return attachmentContainer(index);
          },
        ),
      ),
    );
  }
}
