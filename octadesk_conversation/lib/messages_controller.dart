// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:octadesk_conversation/constants/socket_events.dart';
import 'package:octadesk_conversation/octadesk_conversation.dart';
import 'package:octadesk_conversation/plugins/ntp_offset.dart';
import 'package:octadesk_conversation/room_controller.dart';
import 'package:octadesk_core/dtos/message/attachment_post_dto.dart';
import 'package:octadesk_core/models/message/message_attachment.dart';
import 'package:octadesk_core/models/message/message_paginator_model.dart';
import 'package:octadesk_core/octadesk_core.dart';
import 'package:octadesk_services/octadesk_services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import 'package:collection/collection.dart';

class MessagesController {
  final String roomKey;
  final CancelToken cancelToken;
  final ChatChannelEnum roomChannel;

  ///
  /// Stream de salar
  ///
  late BehaviorSubject<MessagePaginatorModel?> _messagesStreamController;
  Stream<MessagePaginatorModel?> get messagesStream => _messagesStreamController.stream;

  ///
  /// Quantidade de Novas mensagens
  /// -1 = Não está havendo paginação
  /// 0 Paginou mas não tem novas mensagems
  /// > 0 Tem novas mensagens
  final ValueNotifier<int> _newMessagesLength = ValueNotifier(-1);
  ValueNotifier<int> get newMessagesLength => _newMessagesLength;

  /// Carregando página anterior
  final ValueNotifier<bool> _loadingPagination = ValueNotifier(false);
  ValueNotifier<bool> get loadingPagination => _loadingPagination;

  final List<MessageModel> _incomingMessages = [];

  void _handleRoomUpdate(dynamic roomMap) {
    var currentPagination = _messagesStreamController.value;

    // Caso ainda não tenha carregado
    if (currentPagination == null) {
      return;
    }
    // Dados atuais
    final data = RoomDetailDTO.fromMap(roomMap);

    // Caso esteja na última página, atualizar
    if (currentPagination.page == 1) {
      var newPaginator = _messagesStreamController.value!.clone();
      newPaginator.messages = data.messages.reversed.take(15).map((e) => MessageModel.fromDTO(e)).toList();
      newPaginator.page = 1;
      _messagesStreamController.add(newPaginator);
    }
    // Armazenar novas mensagens para adicionar ao fim da paginação
    else {
      var lastMessageKey = _incomingMessages.isEmpty ? currentPagination.messages[0].key : _incomingMessages[0].key;

      // Verificar índice da última mensagem
      var lastMessage = data.messages.firstWhere((element) => element.key == lastMessageKey);
      var lastMessageIndex = data.messages.indexOf(lastMessage);
      var newMessages = data.messages.getRange(lastMessageIndex + 1, data.messages.length).map((e) => MessageModel.fromDTO(e)).toList().reversed.toList();

      _incomingMessages.insertAll(0, newMessages);
      _newMessagesLength.value = _incomingMessages.length;
    }
  }

  ///
  /// Inicializar
  ///
  void _initialize() {
    _messagesStreamController = BehaviorSubject();

    _messagesStreamController.onListen = () async {
      // Adicionar evento de nova mensagem
      OctadeskConversation.instance.socketReference!.on(SocketEvents.roomUpdate, _handleRoomUpdate);
      print("messages_controller: Added room_update listener");

      try {
        var resp = await ChatService.getMessages(roomKey, page: 1, limit: 15);
        _messagesStreamController.add(MessagePaginatorModel.fromDTO(resp));
      } catch (e) {
        _messagesStreamController.addError(e);
      }
    };

    _messagesStreamController.onCancel = () {
      OctadeskConversation.instance.socketReference!.off(SocketEvents.roomUpdate, _handleRoomUpdate);
      print("messages_controller: Removed room_update listener");
    };
  }

  ///
  /// Enviar mensagem
  ///
  Future<void> _handleSendMessage(SendMessageParams params) async {
    var internal = params.isInternal || params.mentions.isNotEmpty;
    var agent = OctadeskConversation.instance.agent!;
    var date = ntpDateTime();

    //Dados a serem enviados
    var dataToSend = MessagePostDTO(
      key: Uuid().v4(),
      time: date.toIso8601String(),
      quotedMessageKey: params.quotedMessage?.key,
      type: internal ? 'internal' : 'public',
      status: 'sending',
      chatKey: roomKey,
      comment: params.message,
      user: agent,
      attachments: params.attachments.map((e) => AttachmentPostDTO.fromFilePath(e)).toList(),
      customFields: {},
      mentions: [...params.mentions],
    );

    if (params.template != null) {
      dataToSend.customFields.addAll({
        'template': params.template!.toMap(),
      });
    }

    // Criar placeholder
    var messagePlaceholder = MessageModel(
      quotedStory: null,
      buttons: params.template?.components.firstWhereOrNull((element) => element.type == MacroComponentTypeEnum.buttons)?.buttons.map((e) => e.label).toList() ?? [],
      quotedMessage: params.quotedMessage != null ? MessageModel.clone(params.quotedMessage!) : null,
      key: dataToSend.key,
      user: AgentModel.fromAgentDTO(agent),
      comment: params.template != null ? generateTemplateContent(params.template!.components) : dataToSend.comment,
      time: date,
      type: internal ? MessageTypeEnum.internal : MessageTypeEnum.public,
      status: MessageStatusEnum.tryingToSend,
      attachments: params.attachments.map((e) => MessageAttachment.fromFilePath(e)).toList(),
      catalog: null,
    );

    var newPaginator = _messagesStreamController.value!.clone();
    if (newPaginator.page == 1) {
      newPaginator.messages.removeLast();
      newPaginator.messages.insert(0, messagePlaceholder);
      _messagesStreamController.add(newPaginator);
    }

    try {
      // Fazer upload dos arquivos
      if (params.attachments.isNotEmpty) {
        var futures = params.attachments.map(
          (e) => ChatService.uploadFile(
            file: File(e),
            channel: roomChannel,
          ),
        );

        var files = await Future.wait(futures);

        for (var i = 0; i < files.length; i++) {
          var ref = dataToSend.attachments[i];
          var file = files[i];

          ref.name = file.name;
          ref.url = file.url;
          ref.thumbnailUrl = file.thumbnailUrl;
        }
      }

      // Enviar a mensagem
      await ChatService.sendMessage(dataToSend);
    } catch (e) {
      if (newPaginator.page == 1) {
        messagePlaceholder.status = MessageStatusEnum.error;
        _messagesStreamController.add(newPaginator);
      }
    }
  }

  MessagesController({required this.roomKey, required this.cancelToken, required this.roomChannel}) {
    _initialize();
  }

  ///
  /// Enviar mensagems
  ///
  Future<void> sendMessage(SendMessageParams params) async {
    //
    // Verificar se é um chat de Whatsapp, caso seja só é permitido um anexo por mensagem
    if (roomChannel == ChatChannelEnum.whatsapp && params.attachments.length > 1) {
      List<Future> futures = [];
      for (var i = 0; i < params.attachments.length; i++) {
        var attachment = params.attachments[i];
        var isLastAttachment = i == params.attachments.length - 1;

        var comment = isLastAttachment ? params.message : "";
        var quoted = isLastAttachment ? params.quotedMessage : null;

        futures.add(
          _handleSendMessage(
            SendMessageParams(
              attachments: [attachment],
              message: comment,
              quotedMessage: quoted,
              isInternal: params.isInternal,
              mentions: params.mentions,
              template: params.template,
            ),
          ),
        );
      }
      await Future.wait(futures);
      return;
    }

    // Caso contrário enviar mensagem normalmente
    await _handleSendMessage(
      SendMessageParams(
        message: params.message,
        attachments: params.attachments,
        quotedMessage: params.quotedMessage,
        isInternal: params.isInternal,
        mentions: params.mentions,
        template: params.template,
      ),
    );
  }

  ///
  /// Carregar próxima página
  ///
  Future<void> loadNextPage() async {
    if (!_loadingPagination.value && _messagesStreamController.value != null) {
      var currentPagination = _messagesStreamController.value!;
      _loadingPagination.value = true;

      // Setar a últiuma mensagem
      if (_newMessagesLength.value < 0) {
        _newMessagesLength.value = 0;
      }

      try {
        var resp = await ChatService.getMessages(roomKey, page: currentPagination.page + 1, limit: 15);
        if (resp.messages.isNotEmpty) {
          var newPaginator = MessagePaginatorModel.fromDTO(resp);

          // Adicionar mensagens anteriores
          newPaginator.messages.insertAll(0, currentPagination.messages);
          _messagesStreamController.add(newPaginator);

          // Página atual
          print("${newPaginator.page}/${newPaginator.pages}");
        }
      } finally {
        Timer(Duration(milliseconds: 500), () {
          _loadingPagination.value = false;
        });
      }
    }
  }

  ///
  /// Atualizar
  ///
  void refresh() async {
    _messagesStreamController.add(null);
    _newMessagesLength.value = -1;
    _loadingPagination.value = true;
    await Future.delayed(Duration(milliseconds: 200));

    try {
      var resp = await ChatService.getMessages(roomKey, page: 1, limit: 15);
      _messagesStreamController.add(MessagePaginatorModel.fromDTO(resp));
    } catch (e) {
      _messagesStreamController.addError(e);
    } finally {
      _loadingPagination.value = false;
    }
  }

  ///
  /// Adicionar mensagens que chegaram
  ///
  void addIncomingMessages() {
    if (_messagesStreamController.value != null && _messagesStreamController.value!.page > 1) {
      var newPaginator = _messagesStreamController.value!.clone();
      newPaginator.page = 1;
      newPaginator.messages.insertAll(0, _incomingMessages);
      newPaginator.messages = newPaginator.messages.take(15).toList();
      _incomingMessages.clear();
      _newMessagesLength.value = -1;
      _messagesStreamController.add(newPaginator);
    }
  }

  Future<void> dispose() async {
    _messagesStreamController.add(null);
    _newMessagesLength.value = -1;
    _loadingPagination.value = false;
    await _messagesStreamController.close();
  }
}
