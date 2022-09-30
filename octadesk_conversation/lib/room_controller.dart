// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';
import 'package:octadesk_conversation/constants/socket_events.dart';
import 'package:octadesk_conversation/octadesk_conversation.dart';
import 'package:octadesk_conversation/plugins/ntp_offset.dart';
import 'package:octadesk_core/dtos/message/attachment_post_dto.dart';
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

  late BehaviorSubject<RoomModel?> _roomStreamController;
  Stream<RoomModel?> get roomStream => _roomStreamController.stream;

  /// Sala atual
  RoomModel? get room => _roomStreamController.value;

  // Se a sala está ativa
  bool get active => !_roomStreamController.isClosed;

  // ====== Métodos privados ======

  /// Verificar se pode mandar apenas mensagens template (WhatsApp Oficial)
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
  Future<void> _handleSendMessage({
    required String message,
    required List<String> attachments,
    required List<AgentDTO> mentions,
    required bool isInternal,
    MessageModel? quotedMessage,
    MacroContentDTO? template,
  }) //
  async {
    var internal = isInternal || mentions.isNotEmpty;
    var agent = OctadeskConversation.instance.agent!;
    var date = ntpDateTime();

    //Dados a serem enviados
    var dataToSend = MessagePostDTO(
      key: Uuid().v4(),
      time: date.toIso8601String(),
      quotedMessageKey: quotedMessage?.key,
      type: internal ? 'internal' : 'public',
      status: 'sending',
      chatKey: room!.key,
      comment: message,
      user: agent,
      attachments: attachments.map((e) => AttachmentPostDTO.fromFilePath(e)).toList(),
      customFields: {},
      mentions: [...mentions],
    );

    if (template != null) {
      dataToSend.customFields.addAll({
        'template': template.toMap(),
      });
    }

    // Nova instancia da sala
    var newRoom = room!.clone();

    // Criar placeholder
    var messagePlaceholder = MessageModel(
      quotedStory: null,
      buttons: template?.components.firstWhereOrNull((element) => element.type == MacroComponentTypeEnum.buttons)?.buttons.map((e) => e.label).toList() ?? [],
      quotedMessage: quotedMessage != null ? MessageModel.clone(quotedMessage) : null,
      key: dataToSend.key,
      user: AgentModel.fromAgentDTO(agent),
      comment: template != null ? generateTemplateContent(template.components) : dataToSend.comment,
      time: date,
      type: internal ? MessageTypeEnum.internal : MessageTypeEnum.public,
      status: MessageStatusEnum.tryingToSend,
      attachments: attachments.map((e) => MessageAttachment.fromFilePath(e)).toList(),
      catalog: null,
    );

    try {
      // Adicionar o placeholder
      newRoom.messages.insert(0, messagePlaceholder);
      _roomStreamController.add(newRoom);

      // Fazer upload dos arquivos
      if (attachments.isNotEmpty) {
        var futures = attachments.map(
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
        final data = RoomDetailDTO.fromMap(room);
        var roomModel = RoomModel.fromDTO(data);

        // Verificar se pode enviar apenas template messages
        roomModel.canSendOnlyTemplateMessages = _checkIfCanSendOnlyTemplateMessages(roomModel);
        _roomStreamController.add(roomModel);
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
  Future<void> sendMessage({
    required String message,
    required List<String> attachments,
    required List<AgentDTO> mentions,
    required bool isInternal,
    MessageModel? quotedMessage,
    MacroContentDTO? template,
  })
  //
  async {
    //
    // Verificar se é um chat de Whatsapp, caso seja só é permitido um anexo por mensagem
    if (room!.channel == ChatChannelEnum.whatsapp && attachments.length > 1) {
      List<Future> futures = [];
      for (var i = 0; i < attachments.length; i++) {
        var attachment = attachments[i];
        var isLastAttachment = i == attachments.length - 1;

        var comment = isLastAttachment ? message : "";
        var quoted = isLastAttachment ? quotedMessage : null;

        futures.add(
          _handleSendMessage(
            attachments: [attachment],
            message: comment,
            quotedMessage: quoted,
            isInternal: isInternal,
            mentions: mentions,
            template: template,
          ),
        );
      }
      await Future.wait(futures);
      return;
    }

    // Caso contrário enviar mensagem normalmente
    await _handleSendMessage(
      message: message,
      attachments: attachments,
      quotedMessage: quotedMessage,
      isInternal: isInternal,
      mentions: mentions,
      template: template,
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
  /// Método de dispose
  ///
  Future<void> dispose() async {
    _roomStreamController.add(null);
    await _roomStreamController.close();
  }
}
