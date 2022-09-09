class TenantEnvironmentDTO {
  final bool acceptNewTenant;
  final bool active;
  final String code;
  final String createdAt;
  final dynamic createdUser;
  final String host;
  final String id;
  final String internalHost;
  final String name;
  final String publicHost;
  final dynamic region;
  final int type;
  final String? updatedAt;
  final String? updatedUser;

  TenantEnvironmentDTO({
    required this.acceptNewTenant,
    required this.active,
    required this.code,
    required this.createdAt,
    required this.createdUser,
    required this.host,
    required this.id,
    required this.internalHost,
    required this.name,
    required this.publicHost,
    required this.region,
    required this.type,
    required this.updatedAt,
    required this.updatedUser,
  });

  factory TenantEnvironmentDTO.fromMap(Map<String, dynamic> map) {
    return TenantEnvironmentDTO(
      acceptNewTenant: map["acceptNewTenant"],
      active: map["active"],
      code: map["code"],
      createdAt: map["createdAt"],
      createdUser: map["createdUser"],
      host: map["host"],
      id: map["id"],
      internalHost: map["internalHost"],
      name: map["name"],
      publicHost: map["publicHost"],
      region: map["region"],
      type: map["type"],
      updatedAt: map["updatedAt"],
      updatedUser: map["updatedUser"],
    );
  }
}
