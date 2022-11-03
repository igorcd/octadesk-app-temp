class OrganizationDTO {
  final int? number;
  final String? name;
  bool? isDefault;
  final String? description;
  final List<dynamic>? domains;
  final Map<dynamic, dynamic>? customField;
  final dynamic domain;
  final String? id;
  final bool? isEnabled;
  final List<dynamic>? phoneContacts;

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

  OrganizationDTO clone() {
    return OrganizationDTO(
      name: name,
      customField: customField,
      description: description,
      domain: domain,
      domains: domains != null ? [...domains!] : null,
      id: id,
      isEnabled: isEnabled,
      number: number,
      phoneContacts: phoneContacts != null ? [...phoneContacts!] : null,
      isDefault: isDefault,
    );
  }

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
