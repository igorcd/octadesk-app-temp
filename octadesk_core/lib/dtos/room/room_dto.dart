import 'package:octadesk_core/dtos/agent/agent_list_dto.dart';
import 'package:octadesk_core/dtos/group/group_dto.dart';
import 'package:octadesk_core/dtos/message/last_message_dto.dart';

class RoomDTO {
  final String key;
  final int number;
  final String channel;
  final GroupDTO? group;
  final String lastMessageDate;
  final AgentListDTO? agent;
  final AgentListDTO createdBy;
  final int status;
  final int unreadMessages;
  final LastMessageDTO? lastMessage;
  final String? closedDate;
  final List<dynamic> publicTags;
  final bool? messageOnNewCollection;
  final dynamic flux;
  final String? clientLastMessageDate;
  final int? clientTimeZone;
  final dynamic integrator;

  RoomDTO({
    required this.key,
    required this.number,
    required this.channel,
    required this.lastMessageDate,
    required this.flux,
    required this.group,
    this.agent,
    required this.createdBy,
    required this.status,
    required this.unreadMessages,
    this.lastMessage,
    this.closedDate,
    required this.publicTags,
    required this.messageOnNewCollection,
    required this.clientLastMessageDate,
    required this.clientTimeZone,
    this.integrator,
  });

  factory RoomDTO.fromMap(Map<String, dynamic> data) {
    return RoomDTO(
      key: data["key"],
      number: data["number"],
      channel: data["channel"],
      lastMessageDate: data["lastMessageDate"],
      agent: data["agent"] != null ? AgentListDTO.fromMap(data["agent"]) : null,
      createdBy: AgentListDTO.fromMap(data["createdBy"]),
      status: data["status"],
      unreadMessages: data["unreadMessages"] ?? 0,
      lastMessage: data["lastMessage"] != null ? LastMessageDTO.fromMap(data["lastMessage"]) : null,
      closedDate: data["closedDate"],
      publicTags: data["publicTags"],
      messageOnNewCollection: data["messageOnNewCollection"],
      flux: data["flux"],
      clientLastMessageDate: data["clientLastMessageDate"],
      clientTimeZone: data["clientTimeZone"],
      group: data["group"] != null ? GroupDTO.fromMap(data["group"]) : null,
      integrator: data["integrator"],
    );
  }
}
