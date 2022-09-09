import 'package:octadesk_core/dtos/index.dart';

class ContactStatusModel {
  final String id;
  final String name;
  final bool isDefault;
  final String displayNameKey;

  ContactStatusModel({
    required this.id,
    required this.name,
    required this.isDefault,
    required this.displayNameKey,
  });

  factory ContactStatusModel.fromDTO(ContactStatusDTO dto) {
    return ContactStatusModel(
      id: dto.id,
      name: dto.name,
      isDefault: dto.isDefault,
      displayNameKey: dto.displayNameKey ?? dto.name,
    );
  }
}
