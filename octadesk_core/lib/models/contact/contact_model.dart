import 'package:octadesk_core/dtos/contact/contact_detail_dto.dart';

class ContactModel {
  final String id;
  final String name;
  final String email;
  final String? thumbUrl;
  final bool active;

  ContactModel({
    required this.id,
    required this.name,
    required this.email,
    required this.thumbUrl,
    required this.active,
  });

  factory ContactModel.fromDTO(ContactDetailDTO dto) {
    return ContactModel(
      id: dto.id,
      active: dto.isEnabled,
      email: dto.email,
      name: dto.name,
      thumbUrl: dto.thumbUrl,
    );
  }
}
