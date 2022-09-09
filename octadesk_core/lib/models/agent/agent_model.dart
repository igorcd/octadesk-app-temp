import 'package:octadesk_core/dtos/agent/agent_dto.dart';
import 'package:octadesk_core/dtos/agent/agent_list_dto.dart';
import 'package:octadesk_core/enums/connection_status_enum.dart';
import 'package:octadesk_core/models/contact/contact_phone_model.dart';

class AgentModel {
  String id;
  String name;
  String email;
  bool active;
  ConnectionStatusEnum connectionStatus;
  List<ContactPhoneModel> phones;
  String? thumbUrl;
  String? group;
  int type;

  AgentModel({
    required this.phones,
    required this.id,
    required this.name,
    required this.email,
    required this.thumbUrl,
    required this.active,
    required this.connectionStatus,
    required this.type,
    this.group,
  });

  factory AgentModel.fromAgentListDTO(AgentListDTO agent, {String? group}) {
    return AgentModel(
      id: agent.id,
      name: agent.name,
      email: agent.email ?? "",
      thumbUrl: agent.thumbUrl,
      group: group,
      active: agent.active ?? false,
      connectionStatus: connectionStatusEnumParser(agent.connectionStatus),
      type: 0,
      phones: [],
    );
  }

  factory AgentModel.fromAgentDTO(AgentDTO agent, {String? group}) {
    return AgentModel(
      id: agent.id,
      name: agent.name,
      email: agent.email,
      thumbUrl: agent.thumbUrl,
      group: group,
      active: agent.active ?? true,
      connectionStatus: connectionStatusEnumParser(agent.connectionStatus ?? 0),
      type: agent.type ?? 0,
      phones: agent.phoneContacts != null ? agent.phoneContacts!.map((e) => ContactPhoneModel.fromDTO(e)).toList() : [],
    );
  }

  AgentModel clone() {
    return AgentModel(
      email: email,
      id: id,
      name: name,
      thumbUrl: thumbUrl,
      active: active,
      connectionStatus: connectionStatus,
      type: type,
      phones: [...phones],
    );
  }
}
