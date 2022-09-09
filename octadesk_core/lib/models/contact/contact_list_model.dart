import 'package:octadesk_core/dtos/agent/agent_dto.dart';
import 'package:octadesk_core/dtos/contact/contact_list_dto.dart';
import 'package:octadesk_core/models/contact/contact_phone_model.dart';

class ContactListModel {
  final String id;
  final String? thumbUrl;
  final String name;
  final List<ContactPhoneModel> phones;

  ContactListModel({required this.id, required this.thumbUrl, required this.name, required this.phones});

  factory ContactListModel.fromDTO(ContactListDTO dto) {
    var name = dto.name.trim();

    return ContactListModel(
      id: dto.id,
      thumbUrl: dto.thumbUrl,
      name: name.isEmpty ? "-" : name,
      phones: dto.phoneContacts.map((e) => ContactPhoneModel.fromDTO(e)).toList(),
    );
  }

  factory ContactListModel.fromAgentDTO(AgentDTO dto) {
    return ContactListModel(
      id: dto.id,
      thumbUrl: dto.thumbUrl,
      name: dto.name,
      phones: dto.phoneContacts != null ? dto.phoneContacts!.map((e) => ContactPhoneModel.fromDTO(e)).toList() : [],
    );
  }
}
