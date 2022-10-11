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

enum PaginationDirection {
  up,
  down,
}

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

  /// Direção que está ocorrendo o scroll
  PaginationDirection _direction = PaginationDirection.up;

  /// Está realizando uma paginação
  bool get isPaginating {
    var paginator = _messagesStreamController.value;
    if (paginator == null) {
      return false;
    }

    return paginator.page > 2 || (paginator.page == 2 && _direction == PaginationDirection.down);
  }

  void _handleRoomUpdate(dynamic roomMap) {
    var currentPagination = _messagesStreamController.value;

    // Caso ainda não tenha carregado
    if (currentPagination == null) {
      return;
    }

    // Caso esteja em uma página maior que a 2
    if (isPaginating) {
      _newMessagesLength.value += 1;
      return;
    }

    _newMessagesLength.value = -1;

    final data = RoomDetailDTO.fromMap(roomMap);
    var newPaginator = _messagesStreamController.value!.clone();

    // Caso esteja na segunda página, atualizar as 30 primeiras
    if (currentPagination.page == 2 && _direction == PaginationDirection.up) {
      newPaginator.messages = data.messages.reversed.take(30).map((e) => MessageModel.fromDTO(e)).toList();
    }
    // Caso não tenha realizado a página atualizar os últimos 15
    else {
      newPaginator.messages = data.messages.reversed.take(15).map((e) => MessageModel.fromDTO(e)).toList();
      _direction = PaginationDirection.up;
    }

    // Quando chega novas mensagens não é possível saber o total, representado pelo valor -1;
    newPaginator.pages = -1;

    // Colocar a página igual a zero, para forçar que realize a paginação

    _messagesStreamController.add(newPaginator);
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
    newPaginator.messages.removeLast();
    newPaginator.messages.insert(0, messagePlaceholder);

    try {
      // Adicionar o placeholder
      if (!isPaginating) {
        _messagesStreamController.add(newPaginator);
      }

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
      if (!isPaginating) {
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

  /// Carregar próxima página
  Future<bool> loadNextPage() async {
    var currentPagination = _messagesStreamController.value;

    /// Quando o currentPagination.pages == -1 signigica que o chat está na página 1 e chegou mensagens novas, nessa situação
    /// não é possível saber qual o total de páginas enquanto não fizer uma nova paginação
    if (!_loadingPagination.value && currentPagination != null && (currentPagination.page < currentPagination.pages || currentPagination.pages == -1)) {
      _loadingPagination.value = true;

      try {
        // Realizar a requisição
        int nextPage = _direction == PaginationDirection.up ? currentPagination.page + 1 : currentPagination.page + 2;

        var resp = await ChatService.getMessages(roomKey, page: nextPage, limit: 15);
        var newPaginator = MessagePaginatorModel.fromDTO(resp);

        // Adicionar mensagens anteriores
        newPaginator.messages.insertAll(0, currentPagination.messages.getRange(currentPagination.messages.length - 15, currentPagination.messages.length));
        _messagesStreamController.add(newPaginator);

        // Mostrar balão de voltar para o começo caso tenha passado da página
        if (_newMessagesLength.value < 0 && newPaginator.page > 2) {
          _newMessagesLength.value = 0;
        }

        _direction = PaginationDirection.up;

        // Página atual
        print("${newPaginator.page}/${newPaginator.pages}");
        return true;
      } finally {
        Timer(Duration(milliseconds: 500), () {
          _loadingPagination.value = false;
        });
      }
    } else {
      return false;
    }
  }

  /// Carregar página anterior
  Future<bool> loadPrevPage() async {
    var currentPagination = _messagesStreamController.value;

    if (!_loadingPagination.value && currentPagination != null && _newMessagesLength.value >= 0) {
      try {
        int nextPage = _direction == PaginationDirection.down ? currentPagination.page - 1 : currentPagination.page - 2;

        // Realizar a requisição
        var resp = await ChatService.getMessages(roomKey, page: nextPage, limit: 15);
        var newPaginator = MessagePaginatorModel.fromDTO(resp);

        // Adicionar mensagens anteriores
        newPaginator.messages.addAll(currentPagination.messages.take(15));
        _messagesStreamController.add(newPaginator);

        // Caso a página seja menor do que a
        if (newPaginator.page == 1) {
          _newMessagesLength.value = -1;
        }

        // Página atual
        print("${newPaginator.page}/${newPaginator.pages}");
        _direction = PaginationDirection.down;
        return true;
      } finally {
        Timer(Duration(milliseconds: 500), () {
          _loadingPagination.value = false;
        });
      }
    } else {
      return false;
    }
  }

  /// Atualizar
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
}
