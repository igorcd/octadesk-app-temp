class TenantDTO {
  final String id;
  final String name;
  final String subdomain;

  TenantDTO({
    required this.id,
    required this.name,
    required this.subdomain,
  });

  factory TenantDTO.fromMap(Map<String, dynamic> map) {
    return TenantDTO(
      id: map["id"],
      name: map["name"],
      subdomain: map["subdomain"] ?? "",
    );
  }
}
