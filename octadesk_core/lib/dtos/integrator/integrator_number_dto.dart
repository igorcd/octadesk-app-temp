class IntegratorNumberDTO {
  final String id;
  final dynamic subDomain;
  final String name;
  final String number;
  final dynamic integrator;
  final dynamic customFields;
  final dynamic privateCustomFields;
  final dynamic createdAt;
  final dynamic updatedAt;

  IntegratorNumberDTO({
    required this.id,
    required this.subDomain,
    required this.name,
    required this.number,
    required this.integrator,
    required this.customFields,
    required this.privateCustomFields,
    required this.createdAt,
    required this.updatedAt,
  });

  factory IntegratorNumberDTO.fromMap(Map<String, dynamic> map) {
    return IntegratorNumberDTO(
      id: map["id"],
      subDomain: map["subDomain"],
      name: map["name"],
      number: map["number"],
      integrator: map["integrator"],
      customFields: map["customFields"],
      privateCustomFields: map["privateCustomFields"],
      createdAt: map["createdAt"],
      updatedAt: map["updatedAt"],
    );
  }
}
