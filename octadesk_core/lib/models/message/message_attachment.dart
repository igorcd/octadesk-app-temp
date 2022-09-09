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
  final int? uploadPercentage;

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
    this.duration,
    required this.name,
    required this.url,
    this.localFilePath,
    this.ptt,
    required this.isUnsupported,
    this.uploadPercentage,
  });

  factory MessageAttachment.fromDTO(MessageAttachmentDTO dto) {
    return MessageAttachment(
      mimeType: dto.mimeType,
      duration: dto.duration,
      name: dto.name,
      url: dto.url,
      thumbnail: dto.thumbnailUrl,
      isUnsupported: dto.isUnsupported,
      uploadPercentage: 0,
    );
  }
}
