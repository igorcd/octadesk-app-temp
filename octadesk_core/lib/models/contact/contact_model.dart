import 'package:octadesk_core/dtos/contact/contact_dto.dart';

class ContactModel {
  final String id;
  final String name;
  final String email;
  final String? thumbUrl;
  final bool active;
  final String? contactStatusId;

  ContactModel({
    required this.id,
    required this.name,
    required this.email,
    required this.thumbUrl,
    required this.active,
    required this.contactStatusId,
  });

  factory ContactModel.fromDTO(ContactDTO dto) {
    return ContactModel(
      id: dto.id,
      active: dto.isEnabled,
      contactStatusId: dto.idContactStatus,
      email: dto.email,
      name: dto.name,
      thumbUrl: dto.thumbUrl,
    );
  }
}
