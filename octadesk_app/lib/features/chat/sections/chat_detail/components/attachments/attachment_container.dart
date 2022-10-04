import 'package:octadesk_app/features/chat/sections/chat_detail/components/attachments/attached_document.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/components/attachments/attached_image.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:octadesk_core/octadesk_core.dart';

class AttachmentContainer extends StatelessWidget {
  final String fileDirectory;
  const AttachmentContainer({required this.fileDirectory, Key? key}) : super(key: key);

  // Referencia ao arquivo
  String get fileName => basename(fileDirectory);

  String get extension {
    var sections = fileName.split('.');
    return sections.length > 1 ? sections[1] : "";
  }

  /// Tipo do arquivo
  AttachmentTypeEnum get type {
    if (["png", "jpg", "jpeg"].contains(extension)) {
      return AttachmentTypeEnum.photo;
    }

    if (["mp4"].contains(extension)) {
      return AttachmentTypeEnum.video;
    }

    if (["mp3", "opus", "wav", "m4a", "ogg", "aac"].contains(extension)) {
      return AttachmentTypeEnum.audio;
    }

    return AttachmentTypeEnum.document;
  }

  /// Renderizar conteúdo
  Widget _renderContent() {
    if (type == AttachmentTypeEnum.photo) {
      return AttachedPicture(fileDirectory);
    }

    String icon = AppIcons.fileFill;
    // Video
    if (type == AttachmentTypeEnum.video) {
      icon = AppIcons.video;
    }
    if (type == AttachmentTypeEnum.audio) {
      icon = AppIcons.music;
    }

    return AttachedDocument(
      extension: extension,
      name: fileName,
      file: fileDirectory,
      icon: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: AppSizes.s34,
      height: AppSizes.s22_5,
      padding: const EdgeInsets.all(AppSizes.s01),

      // Estilização da moldura
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(AppSizes.s03)),
        border: Border.all(
          color: colorScheme.outline,
        ),
      ),
      child: Container(
        clipBehavior: Clip.hardEdge,

        // Estilização do container da imagem
        decoration: BoxDecoration(
          color: colorScheme.background,
          borderRadius: const BorderRadius.all(Radius.circular(AppSizes.s02)),
        ),

        // Conteúdo
        child: _renderContent(),
      ),
    );
  }
}
