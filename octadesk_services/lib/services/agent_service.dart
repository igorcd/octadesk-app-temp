import 'package:octadesk_core/dtos/agent/agent_dto.dart';
import 'package:octadesk_core/dtos/agent/agent_list_dto.dart';
import 'package:octadesk_services/http_clients/octa_client.dart';

class AgentService {
  static Future<List<AgentListDTO>> getAgents() async {
    var resp = await OctaClient.agent.get('');
    return List.from(resp.data).map((e) => AgentListDTO.fromMap(e)).toList();
  }

  static Future<AgentDTO> getAgent(String id) async {
    var resp = await OctaClient.agent.get('/$id');
    return AgentDTO.fromMap(resp.data);
  }
}
