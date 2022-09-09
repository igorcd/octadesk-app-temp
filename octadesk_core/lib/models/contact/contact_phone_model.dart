import 'package:octadesk_core/dtos/contact/contact_phone_dto.dart';

class ContactPhoneModel {
  final int? type;
  final String countryCode;
  final String number;

  ContactPhoneModel({this.type, required this.countryCode, required this.number});

  factory ContactPhoneModel.fromDTO(ContactPhoneDTO dto) {
    return ContactPhoneModel(
      countryCode: dto.countryCode,
      number: dto.number,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "type": type,
      "countryCode": countryCode,
      "number": number,
    };
  }
}
