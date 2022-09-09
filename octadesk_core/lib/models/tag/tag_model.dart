import 'package:octadesk_core/dtos/index.dart';

class TagModel {
  final String id;
  final String status;
  final String name;

  TagModel({required this.id, required this.status, required this.name});

  factory TagModel.fromDTO(TagDTO dto) {
    return TagModel(
      id: dto.id,
      status: dto.status,
      name: dto.name,
    );
  }

  factory TagModel.fromPostDTO(TagPostDTO dto) {
    return TagModel(
      id: dto.id,
      status: "",
      name: dto.name,
    );
  }
}
