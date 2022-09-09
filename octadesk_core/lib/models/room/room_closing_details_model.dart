import 'package:octadesk_core/dtos/room/room_close_details_dto.dart';
import 'package:octadesk_core/models/agent/agent_model.dart';

class RoomClosingDetailsModel {
  final DateTime closedDate;
  final AgentModel closedBy;

  RoomClosingDetailsModel({required this.closedBy, required this.closedDate});

  factory RoomClosingDetailsModel.fromDTO(RoomCloseDetailDTO data) {
    return RoomClosingDetailsModel(
      closedBy: AgentModel.fromAgentDTO(data.user),
      closedDate: DateTime.parse(data.time).toLocal(),
    );
  }
}
