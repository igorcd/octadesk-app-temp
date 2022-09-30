import 'package:octadesk_core/enums/attachment_type_enum.dart';
import 'package:path/path.dart';
import 'package:octadesk_core/dtos/message/message_attachment_dto.dart';

class MessageAttachment {
  final String name;
  final String url;
  final bool isUnsupported;
  final int? duration;
  final String? localFilePath;
  final String? thumbnail;
  final String? mimeType;
  final bool? ptt;

  String get extension {
    var fileUrl = localFilePath ?? url;
    var fileName = basename(fileUrl);
    var sections = fileName.split('.');
    return sections.length > 1 ? sections[1].toLowerCase() : "";
  }

  AttachmentTypeEnum get type {
    if (["png", "jpg", "jpeg"].contains(extension) || (mimeType != null && mimeType!.contains("image"))) {
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

  MessageAttachment({
    required this.mimeType,
    required this.thumbnail,
    required this.name,
    required this.url,
    this.duration,
    this.localFilePath,
    this.ptt,
    required this.isUnsupported,
  });

  factory MessageAttachment.fromFilePath(String path) {
    return MessageAttachment(
      mimeType: null,
      thumbnail: null,
      name: basename(path),
      url: "",
      isUnsupported: false,
    );
  }

  factory MessageAttachment.fromDTO(MessageAttachmentDTO dto) {
    return MessageAttachment(
      mimeType: dto.mimeType,
      name: dto.name,
      url: dto.url,
      thumbnail: dto.thumbnailUrl,
      duration: dto.duration,
      ptt: dto.ptt,
      isUnsupported: dto.isUnsupported,
    );
  }
}
