import 'package:octadesk_core/dtos/index.dart';
import 'package:octadesk_core/dtos/message/attachment_post_dto.dart';

class MessagePostDTO {
  List<AttachmentPostDTO> attachments;
  final String chatKey;
  final String comment;
  final Map<dynamic, dynamic> customFields;
  final List<AgentDTO> mentions;
  final AgentDTO user;
  final String? quotedMessageKey;
  final String key;
  final String status;
  final String time;
  final String type;

  MessagePostDTO({
    required this.chatKey,
    required this.comment,
    required this.customFields,
    required this.attachments,
    required this.key,
    required this.user,
    required this.mentions,
    required this.time,
    required this.type,
    required this.status,
    required this.quotedMessageKey,
  });

  Map<String, dynamic> toMap() {
    return {
      'attachments': attachments.map((e) => e.toMap()).toList(),
      'chatKey': chatKey,
      'comment': comment,
      'customFields': customFields,
      'mentions': mentions.map((e) => e.toMap()).toList(),
      'user': user.toMap(),
      'quotedMessageKey': quotedMessageKey,
      'key': key,
      'status': status,
      'time': time,
      'type': type,
    };
  }
}
