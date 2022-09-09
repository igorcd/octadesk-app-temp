import 'package:octadesk_core/dtos/agent/agent_dto.dart';

class RoomCloseDetailDTO {
  final String time;
  final AgentDTO user;

  RoomCloseDetailDTO({required this.time, required this.user});

  factory RoomCloseDetailDTO.fromMap(Map<String, dynamic> data) {
    return RoomCloseDetailDTO(
      time: data["time"],
      user: AgentDTO.fromMap(data["user"]),
    );
  }
}
