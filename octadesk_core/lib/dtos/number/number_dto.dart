class NumberDTO {
  final dynamic dateCreation;
  final String id;
  final String name;
  final int number;

  final dynamic info;
  final dynamic isEnabled;
  final dynamic lastInactiveCause;
  final dynamic status;
  final dynamic subDomain;
  final dynamic syncSince;

  NumberDTO({
    required this.dateCreation,
    required this.id,
    required this.name,
    required this.number,
    required this.info,
    required this.isEnabled,
    required this.lastInactiveCause,
    required this.status,
    required this.subDomain,
    required this.syncSince,
  });

  factory NumberDTO.fromMap(Map<String, dynamic> map) {
    return NumberDTO(
      dateCreation: map["dateCreation"],
      id: map["id"],
      name: map["name"],
      number: map["number"],
      info: map["info"],
      isEnabled: map["isEnabled"],
      lastInactiveCause: map["lastInactiveCause"],
      status: map["status"],
      subDomain: map["subDomain"],
      syncSince: map["syncSince"],
    );
  }
}
