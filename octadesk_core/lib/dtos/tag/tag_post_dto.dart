import 'package:octadesk_core/models/index.dart';

class TagPostDTO {
  String name;
  String id;

  TagPostDTO({required this.name, required this.id});

  factory TagPostDTO.fromModel(TagModel model) {
    return TagPostDTO(name: model.name, id: model.id);
  }

  factory TagPostDTO.fromMap(Map<String, dynamic> map) {
    return TagPostDTO(
      name: map["name"],
      id: map["_id"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "_id": id,
    };
  }
}
