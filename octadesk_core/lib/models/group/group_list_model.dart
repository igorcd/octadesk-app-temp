import 'package:octadesk_core/dtos/group/group_dto.dart';
import 'package:octadesk_core/models/agent/agent_model.dart';

class GroupListModel {
  final String id;
  final String name;
  final bool enabled;
  final List<AgentModel> agents;

  GroupListModel({
    required this.enabled,
    required this.id,
    required this.name,
    required this.agents,
  });

  factory GroupListModel.fromDTO(GroupDTO dto) {
    return GroupListModel(
      enabled: dto.enabled,
      id: dto.id,
      name: dto.name,
      agents: dto.agents.map((e) => AgentModel.fromAgentListDTO(e, group: dto.name)).toList(),
    );
  }

  factory GroupListModel.clone(GroupListModel model) {
    return GroupListModel(
      enabled: model.enabled,
      id: model.id,
      name: model.name,
      agents: [...model.agents],
    );
  }
}
