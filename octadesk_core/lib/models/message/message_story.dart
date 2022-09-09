class MessageStory {
  final String link;
  final String thumbnailUrl;
  final String username;

  MessageStory({required this.link, required this.thumbnailUrl, required this.username});

  factory MessageStory.fromMap(Map<String, dynamic> map) {
    return MessageStory(
      link: map["link"] ?? "",
      thumbnailUrl: map["thumbnailUrl"] ?? "",
      username: map["username"] ?? "",
    );
  }
}
