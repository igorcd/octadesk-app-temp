class ContactPhoneDTO {
  final String countryCode;
  final String number;
  final dynamic type;
  final dynamic dateCreation;
  final dynamic id;
  final dynamic isEnabled;

  ContactPhoneDTO({
    required this.countryCode,
    required this.number,
    required this.type,
    this.dateCreation,
    this.id,
    this.isEnabled,
  });

  factory ContactPhoneDTO.fromMap(Map<String, dynamic> map) {
    return ContactPhoneDTO(
      countryCode: map["countryCode"],
      number: map["number"],
      type: map["type"],
      dateCreation: map["dateCreation"],
      id: map["dateCreation"],
      isEnabled: map["dateCreation"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "type": type,
      "number": number,
      "countryCode": countryCode,
    };
  }

  String toPhoneNumber() {
    return "+$countryCode$number";
  }
}
