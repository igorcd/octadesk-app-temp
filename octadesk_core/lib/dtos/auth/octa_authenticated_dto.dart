class OctaAuthenticatedDTO {
  final bool admin;
  final String email;
  final String? environmentId;
  final String firstName;
  final String languageCode;
  final String lastName;
  final String? profile;
  final String subDomain;
  final String tenantId;
  final String? timezoneCode;
  final String userId;

  OctaAuthenticatedDTO({
    required this.admin,
    required this.email,
    required this.environmentId,
    required this.firstName,
    required this.languageCode,
    required this.lastName,
    required this.profile,
    required this.subDomain,
    required this.tenantId,
    required this.timezoneCode,
    required this.userId,
  });

  factory OctaAuthenticatedDTO.clone(OctaAuthenticatedDTO data) {
    return OctaAuthenticatedDTO(
      admin: data.admin,
      email: data.email,
      environmentId: data.environmentId,
      firstName: data.firstName,
      languageCode: data.languageCode,
      lastName: data.lastName,
      profile: data.profile,
      subDomain: data.subDomain,
      tenantId: data.tenantId,
      timezoneCode: data.timezoneCode,
      userId: data.userId,
    );
  }

  factory OctaAuthenticatedDTO.fromMap(Map<String, dynamic> data) {
    return OctaAuthenticatedDTO(
      admin: data["admin"] ?? false,
      email: data["email"] ?? "",
      environmentId: data["environmentId"] ?? "",
      firstName: data["firstName"] ?? "",
      languageCode: data["languageCode"] ?? "",
      lastName: data["lastName"] ?? "",
      profile: data["profile"],
      subDomain: data["subDomain"] ?? "",
      tenantId: data["tenantId"] ?? "",
      timezoneCode: data["timezoneCode"] ?? "",
      userId: data["userId"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "admin": admin,
      "email": email,
      "environmentId": environmentId,
      "firstName": firstName,
      "languageCode": languageCode,
      "lastName": lastName,
      "profile": profile,
      "subDomain": subDomain,
      "tenantId": tenantId,
      "timezoneCode": timezoneCode,
      "userId": userId,
    };
  }
}
