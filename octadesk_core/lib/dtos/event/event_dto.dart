import 'package:octadesk_core/dtos/event/event_user_dto.dart';

class EventDTO {
  final String property;
  final String time;
  final EventUserDTO? user;
  final dynamic value;

  EventDTO({required this.property, required this.time, required this.user, required this.value});

  factory EventDTO.fromMap(Map<String, dynamic> data) {
    return EventDTO(
      property: data["property"],
      time: data["time"],
      user: data["user"] != null ? EventUserDTO.fromMap(data["user"]) : null,
      value: data["value"],
    );
  }
}
