import 'package:octadesk_core/dtos/agent/agent_dto.dart';
import 'package:octadesk_core/dtos/event/event_dto.dart';
import 'package:octadesk_core/enums/room_event_type_enum.dart';

class RoomEventModel {
  final RoomEventTypeEnum type;
  final String value;
  final DateTime time;

  RoomEventModel({required this.time, required this.type, required this.value});

  factory RoomEventModel.fromDTO(EventDTO dto) {
    var type = roomEventTypeEnumParser(dto.property);
    var value = "";

    // Caso seja uma mudança de usuário
    if (type == RoomEventTypeEnum.agentChange && dto.value != null) {
      var agent = AgentDTO.fromMap(dto.value);
      value = agent.name;
    }

    // Caso seja uma mudança de grupo
    else if (type == RoomEventTypeEnum.groupChange && dto.value != null) {
      value = dto.value["name"];
    }

    // // Caso seja uma mudança de status
    // else if (type == RoomEventTypeEnum.statusChange) {
    //   value = dto.value.toString();
    // }

    return RoomEventModel(
      type: type,
      value: value,
      time: DateTime.parse(dto.time).toLocal(),
    );
  }
}
