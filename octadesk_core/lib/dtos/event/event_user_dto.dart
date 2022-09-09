class EventUserDTO {
  final String email;
  final String id;

  EventUserDTO({required this.email, required this.id});

  factory EventUserDTO.fromMap(Map<String, dynamic> data) {
    return EventUserDTO(
      email: data["email"],
      id: data["id"],
    );
  }
}
