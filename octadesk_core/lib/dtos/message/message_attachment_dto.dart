class MessageAttachmentDTO {
  final int duration;
  final bool isGif;
  final bool isStory;
  final bool isUnsupported;
  final String name;
  final bool ptt;
  final String? pttMimeType;
  final String? pttUrl;
  final String? thumbnailUrl;
  final String? mimeType;
  final String url;
  final String urlEncrypted;

  MessageAttachmentDTO({
    required this.mimeType,
    required this.duration,
    required this.isGif,
    required this.isStory,
    required this.isUnsupported,
    required this.name,
    required this.ptt,
    required this.pttMimeType,
    required this.pttUrl,
    required this.thumbnailUrl,
    required this.url,
    required this.urlEncrypted,
  });

  factory MessageAttachmentDTO.fromMap(Map<String, dynamic> map) {
    return MessageAttachmentDTO(
      mimeType: map["mimeType"],
      duration: map["duration"],
      isGif: map["isGif"],
      isStory: map["isStory"] ?? false,
      isUnsupported: map["isUnsupported"] ?? false,
      name: map["name"] ?? "",
      ptt: map["ptt"],
      pttMimeType: map["pttMimeType"],
      pttUrl: map["pttUrl"],
      thumbnailUrl: map["thumbnailUrl"],
      url: map["url"],
      urlEncrypted: map["urlEncrypted"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "mimeType": mimeType,
      "duration": duration,
      "isGif": isGif,
      "isStory": isStory,
      "isUnsupported": isUnsupported,
      "name": name,
      "ptt": ptt,
      "pttMimeType": pttMimeType,
      "pttUrl": pttUrl,
      "thumbnailUrl": thumbnailUrl,
      "url": url,
      "urlEncrypted": urlEncrypted,
    };
  }
}
