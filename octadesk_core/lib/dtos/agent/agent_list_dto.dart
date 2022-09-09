class AgentListDTO {
  final String id;
  final String name;
  final int connectionStatus;
  final String? thumbUrl;
  final String? email;
  final bool? active;

  AgentListDTO({
    required this.id,
    required this.name,
    required this.thumbUrl,
    required this.email,
    required this.connectionStatus,
    required this.active,
  });

  factory AgentListDTO.fromMap(Map<String, dynamic> data, {String? group}) {
    return AgentListDTO(
      id: data["id"],
      name: data["name"] ?? "-",
      thumbUrl: data["thumbUrl"],
      email: data["email"],
      connectionStatus: data["connectionStatus"] ?? 0,
      active: data["active"],
    );
  }
}
