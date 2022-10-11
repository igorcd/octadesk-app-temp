import 'package:octadesk_core/dtos/message/message_dto.dart';

class MessagePaginatorDTO {
  final String roomKey;
  final int pages;
  final int limit;
  final int page;
  final List<MessageDTO> messages;
  final List<dynamic> quotedMessages;
  final List<dynamic> users;

  MessagePaginatorDTO({
    required this.roomKey,
    required this.page,
    required this.limit,
    required this.pages,
    required this.messages,
    required this.quotedMessages,
    required this.users,
  });

  factory MessagePaginatorDTO.fromMap(Map<String, dynamic> map) {
    return MessagePaginatorDTO(
      roomKey: map["roomKey"],
      page: map["page"],
      limit: map["limit"],
      pages: map["pages"],
      messages: List.from(map["messages"]).reversed.map((e) => MessageDTO.fromMap(e)).toList(),
      quotedMessages: List.from(map["quotedMessages"]),
      users: List.from(map["users"]),
    );
  }
}
