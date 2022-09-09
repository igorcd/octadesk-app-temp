import 'package:octadesk_core/dtos/agent/agent_list_dto.dart';
import 'package:octadesk_core/dtos/group/group_settings_dto.dart';

class GroupDTO {
  final bool enabled;
  final String id;
  final String name;
  final List<AgentListDTO> agents;
  final GroupSettingsDTO? advancedSettings;

  GroupDTO({
    required this.enabled,
    required this.id,
    required this.name,
    required this.agents,
    required this.advancedSettings,
  });

  factory GroupDTO.fromMap(Map<String, dynamic> map) {
    List<AgentListDTO> agents = map["agents"] != null ? List.from(map["agents"] ?? []).map(((e) => AgentListDTO.fromMap(e, group: map["name"]))).toList() : [];

    return GroupDTO(
      enabled: map["enabled"],
      id: map["id"],
      name: map["name"],
      agents: agents,
      advancedSettings: map["advancedSettings"] != null ? GroupSettingsDTO.fromMap(map["advancedSettings"]) : null,
    );
  }
}
