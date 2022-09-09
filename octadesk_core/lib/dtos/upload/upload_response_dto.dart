class UploadResponseDTO {
  final String name;
  final String url;
  final String? thumbnailUrl;

  UploadResponseDTO({required this.name, required this.url, required this.thumbnailUrl});

  factory UploadResponseDTO.fromMap(Map<String, dynamic> map) {
    return UploadResponseDTO(
      name: map["name"],
      url: map["url"],
      thumbnailUrl: map["thumbnailUrl"],
    );
  }
}
