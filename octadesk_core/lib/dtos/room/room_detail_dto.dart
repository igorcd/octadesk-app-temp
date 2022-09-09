import 'package:octadesk_core/dtos/agent/agent_dto.dart';
import 'package:octadesk_core/dtos/event/event_dto.dart';
import 'package:octadesk_core/dtos/group/group_dto.dart';
import 'package:octadesk_core/dtos/message/message_dto.dart';
import 'package:octadesk_core/dtos/organization/organization_dto.dart';
import 'package:octadesk_core/dtos/room/room_close_details_dto.dart';
import 'package:octadesk_core/dtos/survey/survey_dto.dart';
import 'package:octadesk_core/dtos/widget/widget_environment_dto.dart';

class RoomDetailDTO {
  final AgentDTO? agent;
  final List<dynamic> articles;
  final String channel;
  final String? clientFirstMessageDate;
  final String? clientLastMessageDate;
  final int clientTimeZone;
  final RoomCloseDetailDTO? closed;
  final String created;
  final AgentDTO createdBy;
  final List<dynamic> customFields;
  final String? domainFrom;
  final List<EventDTO> events;
  final List<dynamic> executedRules;
  final List<dynamic> externalKeys;
  final String? id;
  final int ivrWrongAnswers;
  final String key;
  final String? lastDomainFrom;
  final String lastMessageDate;
  final int lastMessageUserType;
  final bool messageOnNewCollection;
  final List<MessageDTO> messages;
  final int number;
  final OrganizationDTO? organization;
  final List<dynamic> previousBotInfos;
  final List<dynamic> previousFluxes;
  final List<dynamic> publicTags;
  final bool sentIvrIntroMessage;
  final List<dynamic> stakeholders;
  final int status;
  final SurveyDTO survey;
  final List<dynamic> tags;
  final String updatedAt;
  final bool useDistributor;
  final List<AgentDTO> users;
  final WidgetEnvironmentDTO widgetEnvironmentInformation;
  final GroupDTO? group;
  final dynamic integrator;

  RoomDetailDTO({
    required this.agent,
    required this.articles,
    required this.channel,
    required this.clientFirstMessageDate,
    required this.clientLastMessageDate,
    required this.clientTimeZone,
    required this.closed,
    required this.created,
    required this.createdBy,
    required this.customFields,
    required this.domainFrom,
    required this.events,
    required this.executedRules,
    required this.externalKeys,
    required this.id,
    required this.ivrWrongAnswers,
    required this.key,
    required this.lastDomainFrom,
    required this.lastMessageDate,
    required this.lastMessageUserType,
    required this.messageOnNewCollection,
    required this.messages,
    required this.number,
    required this.organization,
    required this.previousBotInfos,
    required this.previousFluxes,
    required this.publicTags,
    required this.sentIvrIntroMessage,
    required this.stakeholders,
    required this.status,
    required this.survey,
    required this.tags,
    required this.updatedAt,
    required this.useDistributor,
    required this.users,
    required this.widgetEnvironmentInformation,
    required this.group,
    required this.integrator,
  });

  factory RoomDetailDTO.fromMap(Map<String, dynamic> data) {
    return RoomDetailDTO(
      agent: data["agent"] != null ? AgentDTO.fromMap(data["agent"]) : null,
      articles: List.from(data["articles"]),
      channel: data["channel"],
      clientFirstMessageDate: data["clientFirstMessageDate"],
      clientLastMessageDate: data["clientLastMessageDate"],
      clientTimeZone: data["clientTimeZone"],
      closed: data["closed"] != null ? RoomCloseDetailDTO.fromMap(data["closed"]) : null,
      created: data["created"],
      createdBy: AgentDTO.fromMap(data["createdBy"]),
      customFields: List.from(data["customFields"]),
      domainFrom: data["domainFrom"],
      events: List.from(data["events"]).map((e) => EventDTO.fromMap(e)).toList(),
      executedRules: List.from(data["executedRules"]),
      externalKeys: List.from(data["externalKeys"]),
      id: data["id"],
      ivrWrongAnswers: data["ivrWrongAnswers"],
      key: data["key"],
      lastDomainFrom: data["lastDomainFrom"],
      lastMessageDate: data["lastMessageDate"],
      lastMessageUserType: data["lastMessageUserType"],
      messageOnNewCollection: data["messageOnNewCollection"],
      messages: List.from(data["messages"]).map((m) => MessageDTO.fromMap(m)).toList(),
      number: data["number"],
      organization: data["organization"] != null ? OrganizationDTO.fromMap(data["organization"]) : null,
      previousBotInfos: List.from(data["previousBotInfos"]),
      previousFluxes: List.from(data["previousFluxes"]),
      publicTags: List.from(data["publicTags"]),
      sentIvrIntroMessage: data["sentIvrIntroMessage"],
      stakeholders: List.from(data["stakeholders"]),
      status: data["status"],
      survey: SurveyDTO.fromMap(data["survey"]),
      tags: List.from(data["tags"]),
      updatedAt: data["updatedAt"],
      useDistributor: data["useDistributor"],
      users: List.from(data["users"]).map((u) => AgentDTO.fromMap(u)).toList(),
      widgetEnvironmentInformation: WidgetEnvironmentDTO.fromMap(data["widgetEnvironmentInformation"]),
      group: data["group"] != null ? GroupDTO.fromMap(data["group"]) : null,
      integrator: data["integrator"],
    );
  }
}
