import 'package:octadesk_core/dtos/contact/contact_list_dto.dart';
import 'package:octadesk_core/models/contact/contact_phone_model.dart';

enum ContactTypeEnum { cliente, lead }

String contactTypeEnumParser(ContactTypeEnum type) {
  if (type == ContactTypeEnum.cliente) {
    return "Cliente";
  }
  return "Lead";
}

class ContactListModel {
  final String id;
  final String? thumbUrl;
  final String name;
  final String organizationName;
  final List<ContactPhoneModel> phones;
  final ContactTypeEnum type;

  ContactListModel({
    required this.id,
    required this.thumbUrl,
    required this.name,
    required this.phones,
    required this.organizationName,
    required this.type,
  });

  factory ContactListModel.fromDTO(ContactListDTO dto) {
    var name = dto.name.trim();

    return ContactListModel(
      id: dto.id,
      thumbUrl: dto.thumbUrl,
      name: name.isEmpty ? "-" : name,
      phones: dto.phoneContacts.map((e) => ContactPhoneModel.fromDTO(e)).toList(),
      organizationName: dto.organization?.name ?? "",
      type: ContactTypeEnum.values.firstWhere((element) => element.name == dto.contactStatus.toLowerCase()),
    );
  }
}
