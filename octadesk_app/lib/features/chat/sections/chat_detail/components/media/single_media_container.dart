import 'package:flutter/material.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/components/media/media_audio_container.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/components/media/media_container.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/components/media/media_document_container.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/components/media/media_not_supported_container.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/components/media/media_picture_container.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/components/media/media_video_container.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_core/enums/attachment_type_enum.dart';
import 'package:octadesk_core/models/message/message_attachment.dart';

class SingleMediaContainer extends StatelessWidget {
  final MessageAttachment attachment;
  const SingleMediaContainer(this.attachment, {super.key});

  @override
  Widget build(BuildContext context) {
    if (attachment.isUnsupported) {
      return MediaNotSupportedContainer(attachment: attachment);
    }

    // Caso seja uma imagem
    if (attachment.type == AttachmentTypeEnum.photo) {
      return Padding(
        padding: const EdgeInsets.all(AppSizes.s01_5),
        child: AspectRatio(
          aspectRatio: 1,
          child: MediaContainer(
            child: MediaPictureContainer(attachment: attachment),
          ),
        ),
      );
    }

    // Caso seja um áudio
    if (attachment.type == AttachmentTypeEnum.audio) {
      return SizedBox(
        height: AppSizes.s18,
        child: MediaContainer(
          child: MediaAudioContainer(
            attachment: attachment,
            isVertical: false,
          ),
        ),
      );
    }

    if (attachment.type == AttachmentTypeEnum.video) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.s01_5),
          child: MediaContainer(
            child: MediaVideoContainer(attachment),
          ),
        ),
      );
    }

    return SizedBox(
      height: AppSizes.s18,
      child: MediaContainer(
        child: MediaDocumentContainer(
          attachment: attachment,
          isVertical: false,
        ),
      ),
    );
  }
}
