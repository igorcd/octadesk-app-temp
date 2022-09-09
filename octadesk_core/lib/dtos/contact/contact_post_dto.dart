import 'package:octadesk_core/dtos/contact/contact_list_dto.dart';
import 'package:octadesk_core/dtos/contact/contact_phone_dto.dart';

class ContactPostDTO {
  final String? id;
  final String email;
  final String name;
  final List<ContactPhoneDTO> phoneContacts;
  final dynamic organization;

  ContactPostDTO({
    required this.email,
    required this.name,
    required this.phoneContacts,
    required this.organization,
    this.id,
  });

  factory ContactPostDTO.fromContactListDTO(ContactListDTO contact) {
    return ContactPostDTO(
      email: contact.email,
      name: contact.name,
      phoneContacts: contact.phoneContacts,
      organization: contact.organization,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "email": email,
      "name": name,
      "phoneContacts": phoneContacts.map((e) => e.toMap()).toList(),
      "organization": organization,
    };
  }
}
