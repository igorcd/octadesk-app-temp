class DecodedJwtDTO {
  final String subdomain;
  final String role;
  final String roleType;
  final String email;
  final String name;
  final String type;
  final String id;
  final String permissionType;
  final String permissionView;
  final int nbf;
  final int exp;
  final int iat;
  final String iss;

  DecodedJwtDTO({
    required this.subdomain,
    required this.role,
    required this.roleType,
    required this.email,
    required this.name,
    required this.type,
    required this.id,
    required this.permissionType,
    required this.permissionView,
    required this.nbf,
    required this.exp,
    required this.iat,
    required this.iss,
  });

  factory DecodedJwtDTO.fromMap(Map<String, dynamic> data) {
    return DecodedJwtDTO(
      subdomain: data["subdomain"],
      role: data["role"],
      roleType: data["roleType"],
      email: data["email"],
      name: data["name"],
      type: data["type"],
      id: data["id"],
      permissionType: data["permissionType"],
      permissionView: data["permissionView"],
      nbf: data["nbf"],
      exp: data["exp"],
      iat: data["iat"],
      iss: data["iss"],
    );
  }
}
