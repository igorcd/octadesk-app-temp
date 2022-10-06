// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:octadesk_conversation/constants/socket_events.dart';
import 'package:octadesk_conversation/octadesk_conversation.dart';
import 'package:octadesk_conversation/plugins/ntp_offset.dart';
import 'package:octadesk_core/dtos/message/attachment_post_dto.dart';
import 'package:octadesk_core/dtos/message/messages_pagination_dto.dart';
import 'package:octadesk_core/models/message/message_attachment.dart';
import 'package:octadesk_core/octadesk_core.dart';
import 'package:octadesk_services/octadesk_services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';

class RoomController {
  final String roomKey;
  final CancelToken cancelToken;

  /// Stream da sala
  late BehaviorSubject<RoomModel?> _roomStreamController;
  Stream<RoomModel?> get roomStream => _roomStreamController.stream;

  late BehaviorSubject<MessagesPaginatorDTO?> _messagesStreamController;
  Stream<MessagesPaginatorDTO?> get messagesStream => _messagesStreamController.stream;

  final ValueNotifier<int> _newMessagesLength = ValueNotifier(0);
  ValueNotifier<int> get newMessagesLength => _newMessagesLength;

  /// Sala atual
  RoomModel? get room => _roomStreamController.value;

  // Se a sala está ativa
  bool get active => !_roomStreamController.isClosed;

  // Paginação
  int _currentPage = 1;
  bool _hasPrevPage = true;
  // ====== Métodos privados ======

  ///
  /// Verificar se pode mandar apenas mensagens template (WhatsApp Oficial)
  ///
  bool _checkIfCanSendOnlyTemplateMessages(RoomModel room) {
    // Caso a sala não possua integrator
    if (room.integrator == null || room.integrator?.integratorName == 'octadesk') {
      return false;
    }

    // Caso o cliente não tenha enviado mensagens, pode enviar apenas template
    if (room.clientLastMessageDate == null) {
      return true;
    }

    var integrator = OctadeskConversation.instance.integrators.firstWhere((element) => element.name == room.integrator!.integratorName);
    var intervalFromLastMessage = DateTime.now().toUtc().difference(room.clientLastMessageDate!).inHours;

    return intervalFromLastMessage > integrator.hoursToAnswer - 1;
  }

  ///
  /// Reconectar
  ///
  Future<void> _reconnect(dynamic _) async {
    print("CHAMOU O RECONECT DENTRO DO DETALHE DA SALA");
    if (!_roomStreamController.isClosed) {
      ChatService.readMessages(roomKey);
      OctadeskConversation.instance.socketReference!.emit(SocketEvents.joinRoom, roomKey);
      refreshRoom();
    }
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
      chatKey: room!.key,
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

    // Nova instancia da sala
    var newRoom = room!.clone();

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

    try {
      // Adicionar o placeholder
      // TODO - AJEITAR
      newRoom.messages.insert(0, messagePlaceholder);
      _roomStreamController.add(newRoom);

      // Fazer upload dos arquivos
      if (params.attachments.isNotEmpty) {
        var futures = params.attachments.map(
          (e) => ChatService.uploadFile(
            file: File(e),
            channel: newRoom.channel,
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
      messagePlaceholder.status = MessageStatusEnum.error;
      _roomStreamController.add(newRoom);
    }
  }

  ///
  /// Inicializar
  ///
  void _initialize() {
    var socket = OctadeskConversation.instance.socketReference!;

    // Instanciar a stream
    _roomStreamController = BehaviorSubject<RoomModel?>();

    // Adicionar evento do socket ao iniciar a primeira escuta
    _roomStreamController.onListen = () async {
      print("▶️ COMEÇOU A ESCUTAR A STREAM $roomKey");

      // Adicionar evento de nova mensagem
      socket.on(SocketEvents.roomUpdate, (room) {
        print("▶️ CHEGOU MENSAGEM NA SALA $roomKey");

        if (_currentPage == 1) {
          newMessagesLength.value = 0;
          final data = RoomDetailDTO.fromMap(room);
          var roomModel = RoomModel.fromDTO(data);

          // Verificar se pode enviar apenas template messages
          roomModel.canSendOnlyTemplateMessages = _checkIfCanSendOnlyTemplateMessages(roomModel);
          _roomStreamController.add(roomModel);
        } else {
          newMessagesLength.value += 1;
        }
      });

      // Adicionar o listener para reconexão
      socket.on(SocketEvents.reconnect, _reconnect);

      // Acessar sala
      socket.emit(SocketEvents.joinRoom, roomKey);

      // Carregar dados iniciais
      try {
        var resp = await ChatService.getRoom(roomKey, cancelToken: cancelToken);
        var roomModel = RoomModel.fromDTO(resp);

        roomModel.canSendOnlyTemplateMessages = _checkIfCanSendOnlyTemplateMessages(roomModel);

        if (!_roomStreamController.isClosed) {
          _roomStreamController.add(roomModel);
        }
      } catch (e) {
        // Caso seja apenas cancelar
        if (e is DioError && e.type == DioErrorType.cancel) {
          _roomStreamController.close();
        } else {
          _roomStreamController.addError(e);
        }
      }
    };

    // Quando para de escutar a stream
    _roomStreamController.onCancel = () {
      print("▶️ SAIU DA SALA $roomKey");
      // Sair da sala
      socket.emit(SocketEvents.leaveRoom, roomKey);

      // Parar de escutar o evento
      socket.off(SocketEvents.roomUpdate);
      socket.off(SocketEvents.reconnect, _reconnect);
    };
  }

  ///
  /// Construtor
  ///
  RoomController({required this.roomKey, required this.cancelToken}) {
    _initialize();
  }

  // ====== Métodos públicos =======

  /// Atualizar sala
  Future<void> refreshRoom() async {
    if (!_roomStreamController.isClosed) {
      var resp = await ChatService.getRoom(room!.key);
      var newRoom = RoomModel.fromDTO(resp);
      _roomStreamController.add(newRoom);
    }
  }

  ///
  /// Enviar mensagems
  ///
  Future<void> sendMessage(SendMessageParams params) async {
    //
    // Verificar se é um chat de Whatsapp, caso seja só é permitido um anexo por mensagem
    if (room!.channel == ChatChannelEnum.whatsapp && params.attachments.length > 1 && _roomStreamController.value != null) {
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
  /// Método de finalizar sala
  ///
  Future<void> close() async {
    if (room!.closingDetails == null) {
      var newRoom = room!.clone();
      var agent = OctadeskConversation.instance.agent!;

      try {
        newRoom.closingDetails = RoomClosingDetailsModel(closedBy: AgentModel.fromAgentDTO(agent), closedDate: DateTime.now());
        _roomStreamController.add(newRoom);
        await ChatService.closeChat(newRoom.key, agent);
      } catch (e) {
        newRoom.closingDetails = null;
        _roomStreamController.add(newRoom);
      }
    }
  }

  ///
  /// Assumir conversa
  ///
  Future takeOverChat() async {
    // Agente atual
    var newRoom = room!.clone();
    var currentAgent = room!.agent?.clone();
    var agent = OctadeskConversation.instance.agent!;

    try {
      // Atualizar o agente
      newRoom.agent = AgentModel.fromAgentDTO(agent);
      _roomStreamController.add(newRoom);

      // Realizar a requisição
      await ChatService.assignConversationToAgent(newRoom.key, agent.id);

      // Marcar mensagens como lidas
      ChatService.readMessages(newRoom.key);
    } catch (e) {
      // Em  caso de erro, voltar para o agente anterior
      newRoom.agent = currentAgent;
      _roomStreamController.add(newRoom);
      rethrow;
    }
  }

  ///
  /// Atualizar tags
  ///
  void updateTags(List<TagModel> tags) {
    var newRoom = room!.clone();
    newRoom.tags = [...tags];
    _roomStreamController.add(newRoom);
  }

  ///
  /// Carregar página anterior
  ///
  Future<void> loadPrevPage() async {
    if (_hasPrevPage && room != null) {
      var resp = await ChatService.getMessages(roomKey, page: _currentPage + 1, limit: 15);
      _currentPage = resp.page;
      _hasPrevPage = resp.page < resp.pages;
      var newRoom = room!.clone();

      newRoom.messages.addAll(resp.messages);
      newRoom.messages = [...newRoom.messages, ...resp.messages].take(30);

      print(newRoom);
    }
  }

  ///
  /// Método de dispose
  ///
  Future<void> dispose() async {
    _roomStreamController.add(null);
    await _roomStreamController.close();
  }
}

class SendMessageParams {
  final String message;
  final List<String> attachments;
  final List<AgentDTO> mentions;
  final bool isInternal;
  final MessageModel? quotedMessage;
  final MacroContentDTO? template;

  SendMessageParams({
    required this.message,
    required this.attachments,
    required this.mentions,
    required this.isInternal,
    this.quotedMessage,
    this.template,
  });
}
