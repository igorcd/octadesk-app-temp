import 'package:octadesk_core/dtos/agent/agent_dto.dart';
import 'package:octadesk_core/dtos/message/message_attachment_dto.dart';

class MessageDTO {
  final String? agentRead;
  final List<MessageAttachmentDTO> attachments;
  final String? clientRead;
  final String comment;
  final dynamic customFields;
  final Map<dynamic, dynamic>? extendedData;
  final bool isUnsupportedContent;
  final String key;
  final List<dynamic> mentions;
  final MessageDTO? quotedMessage;
  final dynamic quotedMessageKey;
  final String? roomKey;
  final String status;
  final String time;
  final String type;
  final AgentDTO user;

  MessageDTO({
    required this.agentRead,
    required this.attachments,
    required this.clientRead,
    required this.comment,
    required this.customFields,
    required this.extendedData,
    required this.isUnsupportedContent,
    required this.key,
    required this.mentions,
    required this.quotedMessage,
    required this.quotedMessageKey,
    required this.roomKey,
    required this.status,
    required this.time,
    required this.type,
    required this.user,
  });

  factory MessageDTO.fromMap(Map<String, dynamic> data) {
    return MessageDTO(
      agentRead: data["agentRead"],
      attachments: data["attachments"] != null ? List.from(data["attachments"]).map((e) => MessageAttachmentDTO.fromMap(e)).toList() : [],
      clientRead: data["clientRead"],
      comment: data["comment"] ?? "",
      customFields: data["customFields"],
      extendedData: data["extendedData"] != null ? Map.from(data["extendedData"]) : null,
      isUnsupportedContent: data["isUnsupportedContent"] ?? false,
      key: data["key"],
      mentions: data["mentions"] != null ? List.from(data["mentions"]) : [],
      quotedMessage: data["quotedMessage"] != null ? MessageDTO.fromMap(data["quotedMessage"]) : null,
      quotedMessageKey: data["quotedMessageKey"],
      roomKey: data["roomKey"],
      status: data["status"],
      time: data["time"],
      type: data["type"],
      user: AgentDTO.fromMap(data["user"]),
    );
  }
}
