import 'package:octadesk_core/dtos/message/message_paginator_dto.dart';
import 'package:octadesk_core/models/index.dart';

class MessagePaginatorModel {
  final String roomKey;
  final int limit;
  final List<dynamic> quotedMessages;
  final List<dynamic> users;
  int page;
  int pages;
  List<MessageModel> messages;

  MessagePaginatorModel({
    required this.roomKey,
    required this.page,
    required this.limit,
    required this.pages,
    required this.messages,
    required this.quotedMessages,
    required this.users,
  });

  factory MessagePaginatorModel.fromDTO(MessagePaginatorDTO dto) {
    return MessagePaginatorModel(
      roomKey: dto.roomKey,
      page: dto.page,
      limit: dto.limit,
      pages: dto.pages,
      messages: dto.messages.map((e) => MessageModel.fromDTO(e)).toList(),
      quotedMessages: dto.quotedMessages,
      users: dto.users,
    );
  }

  MessagePaginatorModel clone() {
    return MessagePaginatorModel(
      roomKey: roomKey,
      page: page,
      limit: limit,
      pages: pages,
      messages: [...messages],
      quotedMessages: quotedMessages,
      users: users,
    );
  }
}
