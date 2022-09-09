import 'package:octadesk_core/dtos/index.dart';
import 'package:octadesk_core/enums/chat_channel_enum.dart';
import 'package:octadesk_core/enums/room_status_enum.dart';
import 'package:octadesk_core/models/agent/agent_model.dart';
import 'package:octadesk_core/models/group/group_list_model.dart';

class RoomListModel {
  ChatChannelEnum channel;
  String key;
  String lastMessage;
  bool hasAttachments;
  DateTime lastMessageTime;
  RoomStatusEnum status;
  bool hasNewMessage;
  bool isBot;
  bool isWhatsAppOficial;
  AgentModel user;
  AgentModel? agent;
  List<String>? mentions;
  GroupListModel? group;

  RoomListModel({
    required this.channel,
    required this.key,
    required this.user,
    required this.lastMessage,
    required this.hasAttachments,
    required this.lastMessageTime,
    required this.hasNewMessage,
    required this.status,
    required this.agent,
    required this.isBot,
    required this.mentions,
    required this.group,
    required this.isWhatsAppOficial,
  });

  get isOpened => [RoomStatusEnum.waiting, RoomStatusEnum.talking, RoomStatusEnum.missed, RoomStatusEnum.started].contains(status);

  factory RoomListModel.fromDTO(RoomDTO roomDTO) {
    String getLastMessage() {
      var lastMessage = roomDTO.lastMessage;

      // Caso não tenha mensagem
      if (lastMessage == null) {
        return "Chat iniciado";
      }

      // Caso tenha
      if (lastMessage.comment.isNotEmpty) {
        return lastMessage.comment;
      }

      // Caso seja template de Whatsapp oficial
      // Caso seja template de Whatsapp oficial
      var hasTemplate = lastMessage.customFields != null && lastMessage.customFields["template"] != null;
      if (hasTemplate) {
        return "Template";
      }

      // Caso seja anexo
      if (lastMessage.attachments.isNotEmpty) {
        return "📎 anexo";
      }

      // Caso seja carrinho
      if (lastMessage.order != null) {
        return "🛒 carrinho";
      }

      return "Chat iniciado";
    }

    return RoomListModel(
      hasAttachments: roomDTO.lastMessage?.attachments.isNotEmpty ?? false,
      key: roomDTO.key,
      user: AgentModel.fromAgentListDTO(roomDTO.createdBy),
      lastMessage: getLastMessage(),
      lastMessageTime: DateTime.parse(roomDTO.lastMessageDate).toLocal(),
      hasNewMessage: roomDTO.unreadMessages > 0,
      status: roomDTO.status == 1000 ? RoomStatusEnum.hidden : RoomStatusEnum.values[roomDTO.status],
      channel: chatChannelEnumParser(roomDTO.channel),
      agent: roomDTO.agent != null ? AgentModel.fromAgentListDTO(roomDTO.agent!) : null,
      isBot: roomDTO.flux != null,
      mentions: roomDTO.lastMessage?.mentions != null ? roomDTO.lastMessage!.mentions.map((e) => e['_id'] as String).toList() : [],
      group: roomDTO.group != null ? GroupListModel.fromDTO(roomDTO.group!) : null,
      isWhatsAppOficial: roomDTO.integrator != null && ['360dialog', 'socialminer'].contains(roomDTO.integrator['name']),
    );
  }

  factory RoomListModel.fromRoomDetailDTO(RoomDetailDTO dto) {
    var lastMessage = dto.messages.isEmpty ? null : dto.messages[dto.messages.length - 1];

    return RoomListModel(
      channel: chatChannelEnumParser(dto.channel),
      key: dto.key,
      user: AgentModel.fromAgentDTO(dto.createdBy),
      lastMessage: lastMessage?.comment ?? "",
      hasAttachments: lastMessage?.attachments.isNotEmpty ?? false,
      lastMessageTime: DateTime.parse(dto.lastMessageDate).toLocal(),
      hasNewMessage: false,
      status: dto.status == 1000 ? RoomStatusEnum.hidden : RoomStatusEnum.values[dto.status],
      agent: dto.agent != null ? AgentModel.fromAgentDTO(dto.agent!) : null,
      isBot: false,
      mentions: lastMessage?.mentions != null ? lastMessage!.mentions.map((e) => e['_id'] as String).toList() : [],
      group: dto.group != null ? GroupListModel.fromDTO(dto.group!) : null,
      isWhatsAppOficial: dto.integrator != null && ['360dialog', 'socialminer'].contains(dto.integrator['name']),
    );
  }

  factory RoomListModel.clone(RoomListModel model) {
    return RoomListModel(
      channel: model.channel,
      key: model.key,
      user: model.user.clone(),
      lastMessage: model.lastMessage,
      hasAttachments: model.hasAttachments,
      lastMessageTime: model.lastMessageTime,
      hasNewMessage: model.hasNewMessage,
      status: model.status,
      agent: model.agent != null ? model.agent!.clone() : null,
      isBot: model.isBot,
      mentions: model.mentions != null ? [...model.mentions!] : [],
      group: model.group,
      isWhatsAppOficial: model.isWhatsAppOficial,
    );
  }
}
