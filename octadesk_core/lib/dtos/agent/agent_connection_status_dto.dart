class AgentConnectionStatusDTO {
  final String idAgent;
  final int status;

  AgentConnectionStatusDTO({required this.idAgent, required this.status});

  factory AgentConnectionStatusDTO.fromMap(Map<String, dynamic> map) {
    return AgentConnectionStatusDTO(
      idAgent: map["idAgent"],
      status: map["status"],
    );
  }
}
