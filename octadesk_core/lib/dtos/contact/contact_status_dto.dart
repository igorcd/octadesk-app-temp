class ContactStatusDTO {
  final int idCompany;
  final dynamic createdBy;
  final String? displayNameKey;
  final bool isDefault;
  final String name;
  final String dateCreation;
  final String id;
  final bool isEnabled;

  ContactStatusDTO({
    required this.idCompany,
    required this.createdBy,
    required this.displayNameKey,
    required this.isDefault,
    required this.name,
    required this.dateCreation,
    required this.id,
    required this.isEnabled,
  });

  factory ContactStatusDTO.fromMap(Map<String, dynamic> data) {
    return ContactStatusDTO(
      idCompany: data["idCompany"],
      createdBy: data["createdBy"],
      displayNameKey: data["displayNameKey"],
      isDefault: data["default"],
      name: data["name"],
      dateCreation: data["dateCreation"],
      id: data["id"],
      isEnabled: data["isEnabled"],
    );
  }
}
