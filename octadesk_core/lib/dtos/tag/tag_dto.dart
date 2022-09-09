class TagDTO {
  final String id;
  final String status;
  final String name;
  final String createdAt;
  final String updatedAt;

  TagDTO({required this.id, required this.status, required this.name, required this.createdAt, required this.updatedAt});

  factory TagDTO.fromMap(Map<String, dynamic> map) {
    return TagDTO(
      id: map["id"],
      status: map["status"],
      name: map["name"],
      createdAt: map["createdAt"],
      updatedAt: map["updatedAt"],
    );
  }
}
