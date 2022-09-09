class AttachmentPostDTO {
  String name;
  String url;
  String? thumbnailUrl;
  final int? duration;
  final bool? ptt;

  AttachmentPostDTO({this.duration, this.thumbnailUrl, this.ptt, required this.name, required this.url});

  factory AttachmentPostDTO.fromMap(Map<String, dynamic> map) {
    return AttachmentPostDTO(
      name: map["name"],
      url: map["url"],
      thumbnailUrl: map["thumbnailUrl"],
      duration: map["duration"],
      ptt: map["ppt"],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "name": name,
      "url": url,
    };

    if (thumbnailUrl != null) {
      map["thumbnailUrl"] = thumbnailUrl;
    }

    if (duration != null) {
      map["duration"] = duration;
    }

    if (ptt != null) {
      map["ptt"] = ptt;
    }

    return map;
  }
}
