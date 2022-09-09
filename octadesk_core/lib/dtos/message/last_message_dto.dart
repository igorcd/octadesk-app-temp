import 'package:octadesk_core/dtos/agent/agent_list_dto.dart';

class LastMessageDTO {
  final String? agentRead;
  final List<dynamic> attachments;
  final String? clientRead;
  final String comment;
  final List<dynamic> contactCards;
  final dynamic customFields;
  final dynamic errorCustomCode;
  final dynamic extendedData;
  final bool? isUnsupportedContent;
  final String key;
  final List<dynamic> mentions;
  final String status;
  final String time;
  final String type;
  final AgentListDTO user;
  final dynamic order;

  LastMessageDTO({
    required this.agentRead,
    required this.attachments,
    required this.clientRead,
    required this.comment,
    required this.contactCards,
    required this.customFields,
    required this.errorCustomCode,
    required this.extendedData,
    required this.isUnsupportedContent,
    required this.key,
    required this.mentions,
    required this.status,
    required this.time,
    required this.type,
    required this.user,
    required this.order,
  });

  factory LastMessageDTO.fromMap(Map<String, dynamic> data) {
    return LastMessageDTO(
      agentRead: data["agentRead"],
      attachments: List.from(data["attachments"]),
      clientRead: data["clientRead"],
      comment: data["comment"],
      contactCards: List.from(data["contactCards"]),
      customFields: data["customFields"] != null && data["customFields"] is! List ? Map.from(data["customFields"]) : {},
      errorCustomCode: data["errorCustomCode"],
      extendedData: data["extendedData"],
      isUnsupportedContent: data["isUnsupportedContent"],
      key: data["key"],
      mentions: List.from(data["mentions"]),
      status: data["status"],
      time: data["time"],
      type: data["type"],
      user: AgentListDTO.fromMap(data["user"]),
      order: data["order"],
    );
  }
}
