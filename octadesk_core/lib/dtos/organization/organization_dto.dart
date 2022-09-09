class OrganizationDTO {
  final Map<dynamic, dynamic>? customField;
  final String? description;
  final dynamic domain;
  final List<dynamic>? domains;
  final String? id;
  final bool? isEnabled;
  final String? name;
  final int? number;
  final List<dynamic>? phoneContacts;
  final bool? isDefault;

  OrganizationDTO({
    required this.name,
    required this.customField,
    required this.description,
    required this.domain,
    required this.domains,
    required this.id,
    required this.isEnabled,
    required this.number,
    required this.phoneContacts,
    required this.isDefault,
  });

  factory OrganizationDTO.fromMap(Map<String, dynamic> data) {
    return OrganizationDTO(
      name: data["name"],
      customField: data["customField"] != null ? Map.from(data["customField"]) : null,
      description: data["description"],
      domain: data["domain"],
      domains: data["domains"] != null ? List.from(data["domains"]) : null,
      id: data["id"],
      isEnabled: data["isEnabled"],
      number: data["number"],
      phoneContacts: data["phoneContacts"] != null ? List.from(data["phoneContacts"]) : null,
      isDefault: data["default"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "customField": customField,
      "description": description,
      "domain": domain,
      "domains": domains,
      "id": id,
      "isEnabled": isEnabled,
      "number": number,
      "phoneContacts": phoneContacts,
      "default": isDefault,
    };
  }
}
