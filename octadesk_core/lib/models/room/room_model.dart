import 'package:octadesk_core/dtos/room/room_detail_dto.dart';
import 'package:octadesk_core/enums/chat_channel_enum.dart';
import 'package:octadesk_core/enums/room_event_type_enum.dart';
import 'package:octadesk_core/models/index.dart';
import 'package:collection/collection.dart';
import 'package:octadesk_core/models/room/room_integrator_model.dart';

class RoomModel {
  final String id;
  final String number;
  final DateTime createdAt;
  final ChatChannelEnum channel;
  final String key;
  final AgentModel createdBy;
  final RoomIntegratorModel? integrator;
  final dynamic customFields;
  final DateTime lastMessageDate;
  final DateTime? clientLastMessageDate;

  List<RoomEventModel> events;
  bool canSendOnlyTemplateMessages;
  GroupListModel? group;
  List<TagModel> tags;
  AgentModel? agent;
  RoomClosingDetailsModel? closingDetails;
  List<AgentModel> users;

  RoomModel({
    required this.number,
    required this.id,
    required this.createdAt,
    required this.group,
    required this.channel,
    required this.closingDetails,
    required this.key,
    required this.agent,
    required this.createdBy,
    required this.lastMessageDate,
    required this.events,
    required this.users,
    required this.tags,
    required this.integrator,
    required this.clientLastMessageDate,
    required this.customFields,
    this.canSendOnlyTemplateMessages = false,
  });

  factory RoomModel.fromDTO(RoomDetailDTO data, {int messagesTake = 15}) {
    // Integrator
    var integrator = data.customFields.firstWhereOrNull((element) => element["integrator"] != null);
    var createdAt = DateTime.parse(data.created).toLocal();

    // Eventos
    var events = List.from(data.events).map((e) => RoomEventModel.fromDTO(e)).where((element) => element.type != RoomEventTypeEnum.unknown).toList();
    events.insert(0, RoomEventModel(time: createdAt, type: RoomEventTypeEnum.created, value: "Chat iniciado"));

    return RoomModel(
      id: data.id ?? "",
      number: data.number.toString(),
      createdAt: createdAt,
      channel: chatChannelEnumParser(data.channel),
      key: data.key,
      agent: data.agent != null ? AgentModel.fromAgentDTO(data.agent!) : null,
      createdBy: AgentModel.fromAgentDTO(data.createdBy),
      lastMessageDate: DateTime.parse(data.lastMessageDate).toLocal(),
      closingDetails: data.closed != null ? RoomClosingDetailsModel.fromDTO(data.closed!) : null,
      events: events,
      users: data.users.map((e) => AgentModel.fromAgentDTO(e)).toList(),
      tags: data.publicTags.map((e) => TagModel(id: e["_id"], status: "", name: e["name"])).toList(),
      group: data.group != null ? GroupListModel.fromDTO(data.group!) : null,
      integrator: integrator != null ? RoomIntegratorModel.fromMap(integrator["integrator"]) : null,
      clientLastMessageDate: data.clientLastMessageDate != null ? DateTime.parse(data.clientLastMessageDate!).toLocal() : null,
      customFields: data.customFields,
    );
  }

  RoomModel clone() {
    return RoomModel(
      number: number.toString(),
      id: id,
      createdAt: createdAt,
      agent: agent,
      createdBy: createdBy,
      key: key,
      lastMessageDate: lastMessageDate,
      closingDetails: closingDetails,
      channel: channel,
      events: [...events],
      users: [...users],
      tags: [...tags],
      group: group != null ? GroupListModel.clone(group!) : null,
      integrator: integrator,
      clientLastMessageDate: clientLastMessageDate,
      customFields: customFields,
      canSendOnlyTemplateMessages: canSendOnlyTemplateMessages,
    );
  }

  Map<String, dynamic> getRoomPropertiesAsMap() {
    return {
      "id": id,
      "number": number,
      "createdAt": createdAt.toIso8601String(),
      "channel": channel.name,
      "key": key,
      "createdBy": createdBy.toMap(),
      "lastMessageDate": createdAt.toIso8601String(),
      "customFields": customFields,
    };
  }
}
