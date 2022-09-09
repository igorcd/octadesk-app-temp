class IntegratorDTO {
  final String id;
  final String name;
  final int hoursToAnswer;

  final dynamic supportedExtensions;
  final dynamic channels;
  final dynamic active;

  IntegratorDTO({required this.id, required this.name, required this.supportedExtensions, required this.hoursToAnswer, required this.channels, required this.active});

  factory IntegratorDTO.fromMap(Map<String, dynamic> map) {
    return IntegratorDTO(
      id: map["id"],
      name: map["name"],
      supportedExtensions: map["supportedExtensions"],
      hoursToAnswer: map["hoursToAnswer"],
      channels: map["channels"],
      active: map["active"],
    );
  }
}
